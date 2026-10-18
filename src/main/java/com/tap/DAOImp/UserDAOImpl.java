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

public class UserDAOImpl implements UserDAO{
	
	private static final String INSERT_QUERY = "INSERT INTO user(name, email, password, address, phone, role, createdDate, lastLoginDate)  VALUES(?,?,?,?,?,?,?,?)"; 
	
	private static final String SELECT_USER_BY_EMAIL = "SELECT * FROM user WHERE email=?";
	
	private static final String UPDATE_QUERY = "UPDATE user SET name = ?,  email=?, password=?, address=?, phone=?, role=?, lastLoginDate=? WHERE user_id = ?";
	
	private static final String DELETE_QUERY = "DELETE FROM user WHERE user_id = ?";
	
	private static final String SELECT_ALL_QUERY = "SELECT * from user";
		
	@Override
	public void addUser(User user) {
		try {
			Connection con = DBConnection.getConnection();
			PreparedStatement pstmt = con.prepareStatement(INSERT_QUERY);
			pstmt.setString(1, user.getName());
			pstmt.setString(2, user.getEmail());
			pstmt.setString(3, user.getPassword());
			pstmt.setString(4, user.getAddress());
			pstmt.setString(5, user.getPhone());
			pstmt.setString(6, user.getRole());
			pstmt.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
			pstmt.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
			
			int result = pstmt.executeUpdate();
			System.out.println(result);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public User getUserByEmail(String email) {
		User user = null;
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(SELECT_USER_BY_EMAIL);
			
			pstmt.setString(1, email);
			
			
			ResultSet resultset = pstmt.executeQuery();
			user = extractUserFromResultSet(resultset);
			
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		
		return user;
	}

	private User extractUserFromResultSet(ResultSet res) throws SQLException {
		User user = null;
		while(res.next()) {
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
			
			while(result.next()) {
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
