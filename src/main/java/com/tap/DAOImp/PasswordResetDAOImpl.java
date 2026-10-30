package com.tap.DAOImp;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import com.tap.DAO.PasswordResetDAO;
import com.tap.util.DBConnection;

/** JDBC persistence implementation for email OTP password resets. */
public class PasswordResetDAOImpl implements PasswordResetDAO {
    private static final int MAX_ATTEMPTS = 5;

    @Override
    public Integer findUserIdByEmail(String email) throws SQLException {
        final String sql = "SELECT user_id FROM `user` WHERE email = ? LIMIT 1";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email);
            try (ResultSet result = statement.executeQuery()) {
                return result.next() ? result.getInt("user_id") : null;
            }
        }
    }

    @Override
    public boolean saveOtp(int userId, String otpHash, Timestamp expiresAt) throws SQLException {
        final String recentSql = "SELECT reset_id FROM password_reset_otps "
                + "WHERE user_id = ? AND created_at > DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 60 SECOND) "
                + "ORDER BY reset_id DESC LIMIT 1 FOR UPDATE";
        final String invalidateSql = "UPDATE password_reset_otps SET used_at = CURRENT_TIMESTAMP "
                + "WHERE user_id = ? AND used_at IS NULL";
        final String insertSql = "INSERT INTO password_reset_otps "
                + "(user_id, otp_hash, expires_at, created_at, used_at, attempts) "
                + "VALUES (?, ?, ?, CURRENT_TIMESTAMP, NULL, 0)";

        try (Connection connection = DBConnection.getConnection()) {
            boolean oldAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);
            try {
                try (PreparedStatement recent = connection.prepareStatement(recentSql)) {
                    recent.setInt(1, userId);
                    try (ResultSet result = recent.executeQuery()) {
                        if (result.next()) {
                            connection.rollback();
                            return false; // Cooldown: keep the existing code usable.
                        }
                    }
                }

                try (PreparedStatement invalidate = connection.prepareStatement(invalidateSql)) {
                    invalidate.setInt(1, userId);
                    invalidate.executeUpdate();
                }
                try (PreparedStatement insert = connection.prepareStatement(insertSql)) {
                    insert.setInt(1, userId);
                    insert.setString(2, otpHash);
                    insert.setTimestamp(3, expiresAt);
                    insert.executeUpdate();
                }
                connection.commit();
                return true;
            } catch (SQLException exception) {
                connection.rollback();
                throw exception;
            } finally {
                connection.setAutoCommit(oldAutoCommit);
            }
        }
    }

    @Override
    public boolean verifyOtp(String email, String otpHash) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            boolean oldAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);
            try {
                OtpRecord record = lockCurrentOtp(connection, email);
                if (record == null) {
                    connection.rollback();
                    return false;
                }
                if (record.attempts >= MAX_ATTEMPTS) {
                    markUsed(connection, record.resetId);
                    connection.commit();
                    return false;
                }
                if (!constantTimeEquals(record.otpHash, otpHash)) {
                    registerFailedAttempt(connection, record);
                    connection.commit();
                    return false;
                }
                connection.commit();
                return true;
            } catch (SQLException exception) {
                connection.rollback();
                throw exception;
            } finally {
                connection.setAutoCommit(oldAutoCommit);
            }
        }
    }

    @Override
    public boolean resetPassword(String email, String otpHash, String passwordHash) throws SQLException {
        final String updatePasswordSql = "UPDATE `user` SET password = ? WHERE user_id = ?";
        final String consumeSql = "UPDATE password_reset_otps SET used_at = CURRENT_TIMESTAMP "
                + "WHERE reset_id = ? AND used_at IS NULL AND expires_at > CURRENT_TIMESTAMP AND attempts < ?";

        try (Connection connection = DBConnection.getConnection()) {
            boolean oldAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);
            try {
                OtpRecord record = lockCurrentOtp(connection, email);
                if (record == null || record.attempts >= MAX_ATTEMPTS
                        || !constantTimeEquals(record.otpHash, otpHash)) {
                    connection.rollback();
                    return false;
                }

                try (PreparedStatement updatePassword = connection.prepareStatement(updatePasswordSql)) {
                    updatePassword.setString(1, passwordHash);
                    updatePassword.setInt(2, record.userId);
                    if (updatePassword.executeUpdate() != 1) {
                        connection.rollback();
                        return false;
                    }
                }

                try (PreparedStatement consume = connection.prepareStatement(consumeSql)) {
                    consume.setLong(1, record.resetId);
                    consume.setInt(2, MAX_ATTEMPTS);
                    if (consume.executeUpdate() != 1) {
                        connection.rollback();
                        return false;
                    }
                }

                // Invalidate any other outstanding OTP records for this account.
                try (PreparedStatement invalidate = connection.prepareStatement(
                        "UPDATE password_reset_otps SET used_at = CURRENT_TIMESTAMP "
                        + "WHERE user_id = ? AND used_at IS NULL")) {
                    invalidate.setInt(1, record.userId);
                    invalidate.executeUpdate();
                }

                connection.commit();
                return true;
            } catch (SQLException exception) {
                connection.rollback();
                throw exception;
            } finally {
                connection.setAutoCommit(oldAutoCommit);
            }
        }
    }

    @Override
    public void deleteOtp(String otpHash) throws SQLException {
        final String sql = "DELETE FROM password_reset_otps WHERE otp_hash = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, otpHash);
            statement.executeUpdate();
        }
    }

    private OtpRecord lockCurrentOtp(Connection connection, String email) throws SQLException {
        final String sql = "SELECT t.reset_id, t.user_id, t.otp_hash, t.attempts "
                + "FROM password_reset_otps t JOIN `user` u ON u.user_id = t.user_id "
                + "WHERE u.email = ? AND t.used_at IS NULL AND t.expires_at > CURRENT_TIMESTAMP "
                + "ORDER BY t.created_at DESC, t.reset_id DESC LIMIT 1 FOR UPDATE";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email);
            try (ResultSet result = statement.executeQuery()) {
                if (!result.next()) {
                    return null;
                }
                OtpRecord record = new OtpRecord();
                record.resetId = result.getLong("reset_id");
                record.userId = result.getInt("user_id");
                record.otpHash = result.getString("otp_hash");
                record.attempts = result.getInt("attempts");
                return record;
            }
        }
    }

    private void registerFailedAttempt(Connection connection, OtpRecord record) throws SQLException {
        int nextAttempt = record.attempts + 1;
        final String sql = nextAttempt >= MAX_ATTEMPTS
                ? "UPDATE password_reset_otps SET attempts = ?, used_at = CURRENT_TIMESTAMP WHERE reset_id = ? AND used_at IS NULL"
                : "UPDATE password_reset_otps SET attempts = ? WHERE reset_id = ? AND used_at IS NULL";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, nextAttempt);
            statement.setLong(2, record.resetId);
            statement.executeUpdate();
        }
    }

    private void markUsed(Connection connection, long resetId) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(
                "UPDATE password_reset_otps SET used_at = CURRENT_TIMESTAMP WHERE reset_id = ? AND used_at IS NULL")) {
            statement.setLong(1, resetId);
            statement.executeUpdate();
        }
    }

    private boolean constantTimeEquals(String storedHash, String submittedHash) {
        if (storedHash == null || submittedHash == null) {
            return false;
        }
        byte[] stored = storedHash.trim().getBytes(StandardCharsets.US_ASCII);
        byte[] submitted = submittedHash.trim().getBytes(StandardCharsets.US_ASCII);
        return MessageDigest.isEqual(stored, submitted);
    }

    private static final class OtpRecord {
        private long resetId;
        private int userId;
        private String otpHash;
        private int attempts;
    }
}
