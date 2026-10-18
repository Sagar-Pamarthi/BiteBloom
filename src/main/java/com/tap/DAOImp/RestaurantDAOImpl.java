package com.tap.DAOImp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.RestaurantDAO;
import com.tap.model.Restaurant;
import com.tap.util.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO{

	private static final String INSERT_QUERY = "INSERT INTO restaurant(name,cuisine_type,delivery_time,"
			+ "address,rating,is_active,imagepath) VALUES (?,?,?,?,?,?,?)";
	
	private static final String SELECT_QUERY = "SELECT * FROM restaurant WHERE restaurant_id = ?";
	
	private static final String UPDATE_QUERY = "UPDATE restaurant SET name = ?, cuisine_type = ?, delivery_time = ?, "
			+ "address = ?, rating = ?, is_active = ?, imagepath = ? WHERE restaurant_id = ?";
	
	private static final String DELETE_QUERY = "DELETE FROM restaurant where restaurant_id = ?";
	
	private static final String SELECT_ALL_QUERY = "SELECT * FROM restaurant";
	
	
	
	@Override
	public void addRestaurant(Restaurant restaurant) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
			
			pstmt.setString(1, restaurant.getName());
			pstmt.setString(2, restaurant.getCuisine_type());
			pstmt.setInt(3, restaurant.getDelivery_time());
			pstmt.setString(4, restaurant.getAddress());
			pstmt.setFloat(5, restaurant.getRating());
			pstmt.setBoolean(6, restaurant.isIs_active());
			pstmt.setString(7, restaurant.getImagepath());

			int result = pstmt.executeUpdate();
			System.out.println(result);
			
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		
	}

	@Override
	public Restaurant getRestaurant(int restaurant_id) {
		
		Connection connection = DBConnection.getConnection();
		Restaurant restaurant = null;
		try {
			PreparedStatement pstmt = connection.prepareStatement(SELECT_QUERY);
			
			pstmt.setInt(1, restaurant_id);
			
			ResultSet resultSet = pstmt.executeQuery();
			
			restaurant = extractRestaurantFromResultSet(resultSet); 
			
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		
		
		return restaurant;
	}

	public Restaurant extractRestaurantFromResultSet(ResultSet resultSet) throws SQLException {
		
		Restaurant restaurant = null;
		
		while(resultSet.next()) {
			int restaurant_id = resultSet.getInt(1);
			String name = resultSet.getString(2);
			String cuisine_type = resultSet.getString(3);
			int delivery_time = resultSet.getInt(4);
			String address = resultSet.getString(5);
			float rating = resultSet.getFloat(6);
			boolean is_active = resultSet.getBoolean(7);
			String imagepath = resultSet.getString(8);
			
			restaurant = new Restaurant(restaurant_id,name,cuisine_type,delivery_time,address,rating,is_active,imagepath);
			
		}
		return restaurant;
	}
	
	
	@Override
	public void updateRestaurant(Restaurant restaurant) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);
			
			pstmt.setString(1, restaurant.getName());
			pstmt.setString(2, restaurant.getCuisine_type());
			pstmt.setInt(3, restaurant.getDelivery_time());
			pstmt.setString(4, restaurant.getAddress());
			pstmt.setFloat(5, restaurant.getRating());
			pstmt.setBoolean(6, restaurant.isIs_active());
			pstmt.setInt(7, restaurant.getRestaurant_id());
			pstmt.setString(8, restaurant.getImagepath());
			
			int result = pstmt.executeUpdate();
			System.out.println(result);
			
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		
	}

	@Override
	public void deleteRestaurant(int restaurant_id) {
		
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(DELETE_QUERY);
			
			pstmt.setInt(1, restaurant_id);
			
			int result = pstmt.executeUpdate();
			System.out.println(result);
			
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		
	}

	@Override
	public List<Restaurant> getAllRestaurants() {
		
		List<Restaurant> allRestaurants = new ArrayList<Restaurant>();
		
		Connection connection = DBConnection.getConnection();
		try {
			Statement stmt = connection.createStatement();
			ResultSet resultSet = stmt.executeQuery(SELECT_ALL_QUERY);
			
			while(resultSet.next()) {
				int restaurant_id = resultSet.getInt(1);
				String name = resultSet.getString(2);
				String cuisine_type = resultSet.getString(3);
				int delivery_time = resultSet.getInt(4);
				String address = resultSet.getString(5);
				float rating = resultSet.getFloat(6);
				boolean is_active = resultSet.getBoolean(7);
				String imagepath = resultSet.getString(8);
				
				Restaurant restaurant = new Restaurant(restaurant_id,name,cuisine_type,delivery_time,address,rating,is_active,imagepath);
				allRestaurants.add(restaurant);
			}
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return allRestaurants;
	}

}
