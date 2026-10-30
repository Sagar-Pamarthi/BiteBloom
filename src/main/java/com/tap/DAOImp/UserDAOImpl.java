package com.tap.DAOImp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.UserDAO;
import com.tap.model.User;
import com.tap.util.DBConnection;

public class UserDAOImpl implements UserDAO {

    private static final String INSERT_QUERY =
            "INSERT INTO user(name, email, password, address, phone, role, createdDate, lastLoginDate) VALUES(?,?,?,?,?,?,?,?)";
    private static final String SELECT_USER_BY_EMAIL = "SELECT * FROM user WHERE email=?";
    private static final String UPDATE_QUERY =
            "UPDATE user SET name = ?, email=?, password=?, address=?, phone=?, role=?, lastLoginDate=? WHERE user_id = ?";
    private static final String DELETE_QUERY = "DELETE FROM user WHERE user_id = ?";
    private static final String SELECT_ALL_QUERY = "SELECT * FROM user";
    private static final String UPDATE_ADDRESS_QUERY = "UPDATE user SET address = ? WHERE user_id = ?";
    private static final String USER_EXISTS_QUERY = "SELECT user_id FROM user WHERE user_id = ?";


@Override
public boolean addUser(User user) {

    try (Connection con = DBConnection.getConnection()) {

        if (con == null) {
            return false;
        }

        try (PreparedStatement pstmt = con.prepareStatement(INSERT_QUERY)) {

            pstmt.setString(1, user.getName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPassword());
            pstmt.setString(4, user.getAddress());
            pstmt.setString(5, user.getPhone());
            pstmt.setString(6, user.getRole());

            Timestamp currentTime =
                    new Timestamp(System.currentTimeMillis());

            pstmt.setTimestamp(7, currentTime);
            pstmt.setTimestamp(8, currentTime);

            int result = pstmt.executeUpdate();

            return result == 1;
        }

    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}


    @Override
    public User getUserByEmail(String email) {
        User user = null;
        try (Connection connection = DBConnection.getConnection()) {
            if (connection == null) {
                return null;
            }
            try (PreparedStatement pstmt = connection.prepareStatement(SELECT_USER_BY_EMAIL)) {
                pstmt.setString(1, email);
                try (ResultSet resultset = pstmt.executeQuery()) {
                    user = extractUserFromResultSet(resultset);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    private User extractUserFromResultSet(ResultSet res) throws SQLException {
        User user = null;
        while (res.next()) {
            int user_id = res.getInt(1);
            String name = res.getString(2);
            String email = res.getString(3);
            String password = res.getString(4);
            String address = res.getString(5);
            String phone = res.getString(6);
            String role = res.getString(7);
            Timestamp createdDate = res.getTimestamp(8);
            Timestamp lastLoginDate = res.getTimestamp(9);
            user = new User(user_id, name, email, password, address, phone, role, createdDate, lastLoginDate);
        }
        return user;
    }

    @Override
    public void updateUser(User user) {
        Connection connection = DBConnection.getConnection();
        try {
            PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);
            pstmt.setString(1, user.getName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPassword());
            pstmt.setString(4, user.getAddress());
            pstmt.setString(5, user.getPhone());
            pstmt.setString(6, user.getRole());
            pstmt.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
            pstmt.setInt(8, user.getUser_id());
            int result = pstmt.executeUpdate();
            System.out.println(result);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /** Saves only the current address without rewriting the user's other profile fields. */
    @Override
    public boolean updateAddress(int userId, String address) {
        Connection connection = DBConnection.getConnection();
        if (connection == null) {
            return false;
        }

        try (Connection con = connection;
             PreparedStatement pstmt = con.prepareStatement(UPDATE_ADDRESS_QUERY)) {
            pstmt.setString(1, address);
            pstmt.setInt(2, userId);
            int updatedRows = pstmt.executeUpdate();
            if (updatedRows > 0) {
                return true;
            }

            // MySQL may report zero changed rows when the saved address was already identical.
            try (PreparedStatement check = con.prepareStatement(USER_EXISTS_QUERY)) {
                check.setInt(1, userId);
                try (ResultSet rs = check.executeQuery()) {
                    return rs.next();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Updates one allowed profile column without rewriting password, role, or login metadata. */
    public boolean updateProfileField(int userId, String field, String value) {
        String column;
        switch (field == null ? "" : field.trim().toLowerCase(java.util.Locale.ROOT)) {
            case "name":
                column = "name";
                break;
            case "email":
                column = "email";
                break;
            case "phone":
                column = "phone";
                break;
            case "address":
                column = "address";
                break;
            default:
                return false;
        }

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                return false;
            }

            // Do not allow the profile to claim an email already used by another account.
            if ("email".equals(column)) {
                try (PreparedStatement checkEmail = con.prepareStatement(
                        "SELECT user_id FROM user WHERE email = ? AND user_id <> ?")) {
                    checkEmail.setString(1, value);
                    checkEmail.setInt(2, userId);
                    try (ResultSet rs = checkEmail.executeQuery()) {
                        if (rs.next()) {
                            return false;
                        }
                    }
                }
            }

            // 'column' is selected only by the fixed whitelist above.
            String updateSql = "UPDATE user SET " + column + " = ? WHERE user_id = ?";
            try (PreparedStatement update = con.prepareStatement(updateSql)) {
                update.setString(1, value);
                update.setInt(2, userId);
                if (update.executeUpdate() > 0) {
                    return true;
                }
            }

            // MySQL may report zero updated rows if the field was already equal to this value.
            String checkSql = "SELECT " + column + " FROM user WHERE user_id = ?";
            try (PreparedStatement check = con.prepareStatement(checkSql)) {
                check.setInt(1, userId);
                try (ResultSet rs = check.executeQuery()) {
                    return rs.next() && java.util.Objects.equals(value, rs.getString(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public void deleteUser(int user_id) {
        Connection connection = DBConnection.getConnection();
        try {
            PreparedStatement pstmt = connection.prepareStatement(DELETE_QUERY);
            pstmt.setInt(1, user_id);
            int result = pstmt.executeUpdate();
            System.out.println(result);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<User> getAllUsers() {
        List<User> allUsers = new ArrayList<>();
        Connection connection = DBConnection.getConnection();
        try {
            Statement stmt = connection.createStatement();
            ResultSet result = stmt.executeQuery(SELECT_ALL_QUERY);
            while (result.next()) {
                int user_id = result.getInt(1);
                String name = result.getString(2);
                String email = result.getString(3);
                String password = result.getString(4);
                String address = result.getString(5);
                String phone = result.getString(6);
                String role = result.getString(7);
                Timestamp createdDate = result.getTimestamp(8);
                Timestamp lastLoginDate = result.getTimestamp(9);
                User user = new User(user_id, name, email, password, address, phone, role, createdDate, lastLoginDate);
                allUsers.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return allUsers;
    }
}
