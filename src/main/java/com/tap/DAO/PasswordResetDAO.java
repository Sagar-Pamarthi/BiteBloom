package com.tap.DAO;

import java.sql.SQLException;
import java.sql.Timestamp;

/** Persistence contract for email OTP password resets. */
public interface PasswordResetDAO {
    Integer findUserIdByEmail(String email) throws SQLException;

    /** Creates a new OTP if the account has not requested one in the last 60 seconds. */
    boolean saveOtp(int userId, String otpHash, Timestamp expiresAt) throws SQLException;

    /** Checks an OTP and increments the failed-attempt counter for incorrect codes. */
    boolean verifyOtp(String email, String otpHash) throws SQLException;

    /** Atomically changes the password and consumes the matching, valid OTP. */
    boolean resetPassword(String email, String otpHash, String passwordHash) throws SQLException;

    /** Removes an OTP when sending its email fails. */
    void deleteOtp(String otpHash) throws SQLException;
}
