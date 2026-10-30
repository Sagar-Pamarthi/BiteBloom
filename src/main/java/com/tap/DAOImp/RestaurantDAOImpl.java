package com.tap.DAOImp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

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
			pstmt.setString(7, restaurant.getImagepath());
			pstmt.setInt(8, restaurant.getRestaurant_id());
			
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
	
	@Override
	public List<Restaurant> getRestaurantsByFoodCategoryAndSearch(
	        String foodCategory, String search) {

	    List<Restaurant> restaurants = new ArrayList<>();

	    String selectedCategory =
	            (foodCategory == null || foodCategory.isBlank()
	                    || foodCategory.equalsIgnoreCase("all"))
	                    ? "" : foodCategory.trim();

	    String searchTerm =
	            search == null ? "" : search.trim().toLowerCase(Locale.ROOT);

	    String[] categoryValues = new String[0];
	    String[] dishKeywords = new String[0];

	    StringBuilder sql = new StringBuilder(
	            "SELECT r.* FROM restaurant r WHERE 1 = 1 ");

	    // Filter restaurants by the food in their menu.
	    if (!selectedCategory.isEmpty()) {

	        categoryValues = getCategoryAliases(selectedCategory);
	        dishKeywords = getDishKeywords(selectedCategory);

	        sql.append(
	            "AND EXISTS ( " +
	            "SELECT 1 FROM menu m " +
	            "WHERE m.restaurant_id = r.restaurant_id " +
	            "AND m.is_available = 1 " +
	            "AND ( " +
	            "LOWER(TRIM(COALESCE(m.category, ''))) IN ("
	        );

	        sql.append(placeholders(categoryValues.length));
	        sql.append(") OR (");

	        appendLikeConditions(sql, "m.itemName", dishKeywords.length);

	        sql.append(")) ) ");
	    }

	    // Search can be combined with the selected food category.
	    if (!searchTerm.isEmpty()) {
	        sql.append(
	            "AND ( " +
	            "LOWER(COALESCE(r.name, '')) LIKE ? " +
	            "OR LOWER(COALESCE(r.address, '')) LIKE ? " +
	            "OR LOWER(COALESCE(r.cuisine_type, '')) LIKE ? " +
	            "OR EXISTS ( " +
	                "SELECT 1 FROM menu sm " +
	                "WHERE sm.restaurant_id = r.restaurant_id " +
	                "AND sm.is_available = 1 " +
	                "AND ( " +
	                    "LOWER(COALESCE(sm.itemName, '')) LIKE ? " +
	                    "OR LOWER(COALESCE(sm.category, '')) LIKE ? " +
	                ") " +
	            ") " +
	            ") "
	        );
	    }

	    sql.append("ORDER BY r.restaurant_id");

	    try (Connection connection = DBConnection.getConnection();
	         PreparedStatement pstmt =
	                 connection.prepareStatement(sql.toString())) {

	        int index = 1;

	        if (!selectedCategory.isEmpty()) {

	            for (String value : categoryValues) {
	                pstmt.setString(index++, value.toLowerCase(Locale.ROOT));
	            }

	            for (String keyword : dishKeywords) {
	                pstmt.setString(
	                    index++, "%" + keyword.toLowerCase(Locale.ROOT) + "%");
	            }
	        }

	        if (!searchTerm.isEmpty()) {
	            String pattern = "%" + searchTerm + "%";

	            pstmt.setString(index++, pattern);
	            pstmt.setString(index++, pattern);
	            pstmt.setString(index++, pattern);
	            pstmt.setString(index++, pattern);
	            pstmt.setString(index++, pattern);
	        }

	        try (ResultSet rs = pstmt.executeQuery()) {
	            while (rs.next()) {
	                Restaurant restaurant = new Restaurant();

	                restaurant.setRestaurant_id(
	                        rs.getInt("restaurant_id"));
	                restaurant.setName(rs.getString("name"));
	                restaurant.setCuisine_type(
	                        rs.getString("cuisine_type"));
	                restaurant.setDelivery_time(
	                        rs.getInt("delivery_time"));
	                restaurant.setAddress(rs.getString("address"));
	                restaurant.setRating(rs.getFloat("rating"));
	                restaurant.setIs_active(rs.getBoolean("is_active"));
	                restaurant.setImagepath(rs.getString("imagepath"));

	                restaurants.add(restaurant);
	            }
	        }

	    } catch (SQLException e) {
	        throw new RuntimeException(
	                "Unable to filter restaurants by food category.", e);
	    }

	    return restaurants;
	}


	// Map category labels to common database spelling variations.
	private String[] getCategoryAliases(String foodCategory) {

	    String category = foodCategory.trim().toLowerCase(Locale.ROOT);

	    switch (category) {
	        case "burger":
	        case "burgers":
	            return new String[] {"burger", "burgers"};

	        case "cake":
	        case "cakes":
	            return new String[] {"cake", "cakes"};

	        case "ice cream":
	            return new String[] {"ice cream", "icecream", "ice creams"};

	        case "juice":
	        case "juices":
	            return new String[] {"juice", "juices"};

	        case "idly":
	        case "idli":
	            return new String[] {"idly", "idli"};

	        case "roll":
	        case "rolls":
	            return new String[] {"roll", "rolls"};

	        case "south indian":
	            return new String[] {"south indian", "south-indian"};

	        case "north indian":
	            return new String[] {"north indian", "north-indian"};

	        default:
	            return new String[] {category};
	    }
	}


	// Match categories against actual dish names as well as menu.category.
	private String[] getDishKeywords(String foodCategory) {

	    String category = foodCategory.trim().toLowerCase(Locale.ROOT);

	    switch (category) {
	        case "south indian":
	            return new String[] {
	                "south indian", "dosa", "idly", "idli", "uttapam",
	                "vada", "pongal", "upma", "appam", "puttu"
	            };

	        case "north indian":
	            return new String[] {
	                "north indian", "naan", "roti", "paratha",
	                "paneer", "chole", "kulcha", "rajma",
	                "tikka", "dal makhani"
	            };

	        case "chinese":
	            return new String[] {
	                "chinese", "noodles", "manchurian", "fried rice"
	            };

	        case "burger":
	        case "burgers":
	            return new String[] {"burger"};

	        case "cake":
	        case "cakes":
	            return new String[] {"cake"};

	        case "ice cream":
	            return new String[] {"ice cream", "icecream"};

	        case "juice":
	        case "juices":
	            return new String[] {"juice"};

	        case "idly":
	        case "idli":
	            return new String[] {"idly", "idli"};

	        case "roll":
	        case "rolls":
	            return new String[] {"roll", "frankie"};

	        default:
	            return new String[] {category};
	    }
	}


	// Build the correct number of SQL placeholders.
	private String placeholders(int count) {

	    StringBuilder result = new StringBuilder();

	    for (int i = 0; i < count; i++) {
	        if (i > 0) {
	            result.append(", ");
	        }
	        result.append("?");
	    }

	    return result.toString();
	}


	// Append parameterized item-name conditions.
	private void appendLikeConditions(
	        StringBuilder sql, String column, int count) {

	    for (int i = 0; i < count; i++) {
	        if (i > 0) {
	            sql.append(" OR ");
	        }

	        sql.append("LOWER(COALESCE(")
	           .append(column)
	           .append(", '')) LIKE ?");
	    }
	}
}
