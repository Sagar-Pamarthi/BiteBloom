package com.tap.DAOImp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.MenuDAO;
import com.tap.model.Menu;
import com.tap.util.DBConnection;

public class MenuDAOImpl implements MenuDAO{

	private static final String INSERT_QUERY = "INSERT INTO menu(restaurant_id,itemName,price,is_available,category,"
			+ "createdAt,updatedAt,deletedAt,imagePath,dishType,description) VALUES(?,?,?,?,?,?,?,?,?,?,?)";
	
	private static final String SELECT_QUERY = "SELECT * FROM menu where menu_id = ?";
	
	private static final String UPDATE_QUERY = "UPDATE menu SET restaurant_id = ?, itemName = ?, price = ?, "
			+ "is_available = ?, category = ?, updatedAt = ?, imagePath = ?, dishType = ?, description = ? WHERE menu_id = ?";
	
	private static final String DELETE_QUERY = "DELETE FROM menu WHERE menu_id = ?";
	
	private static final String SELECT_ALL_QUERY = "SELECT * FROM menu";
	
	private static final String MENU_BY_RESTAURANT_ID = "SELECT menu_id, restaurant_id, itemName, price, is_available, category, imagePath,"
			+ "dishType,description FROM menu WHERE restaurant_id = ?";
	
	@Override
	public void addMenu(Menu menu) {
		
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
			
			pstmt.setInt(1, menu.getRestaurant_id());
			pstmt.setString(2, menu.getItemName());
			pstmt.setFloat(3, menu.getPrice());
			pstmt.setInt(4, menu.getIs_available());
			pstmt.setString(5, menu.getCategory());
			pstmt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
			pstmt.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
			pstmt.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
			pstmt.setString(9, menu.getImagePath());
			pstmt.setString(10, menu.getDishType());
			pstmt.setString(11, menu.getDescription());
			
			int result = pstmt.executeUpdate();
			System.out.println(result);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public Menu getMenu(int menu_id) {
		
		Connection connection = DBConnection.getConnection();
		Menu menu = null;
		try {
			PreparedStatement pstmt = connection.prepareStatement(SELECT_QUERY);
			
			pstmt.setInt(1, menu_id);
			
			ResultSet result = pstmt.executeQuery();
			menu = extractMenuFromResultSet(result);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return menu;
	}

	public Menu extractMenuFromResultSet(ResultSet result) throws SQLException {
	
		Menu menu = null;
		while(result.next()) {
			int menu_id = result.getInt(1);
			int restaurant_id = result.getInt(2);
			String itemName = result.getString(3);
			float price = result.getFloat(4);
			int is_available = result.getInt(5);
			String category = result.getString(6);
			Timestamp createdAt = result.getTimestamp(7);
			Timestamp updatedAt = result.getTimestamp(8);
			Timestamp deletedAt = result.getTimestamp(9);
			String imagePath = result.getString(10);
			String dishType = result.getString(11);
			String description = result.getString(12);
			
			menu = new Menu(menu_id,restaurant_id,itemName,price,is_available,category,createdAt,updatedAt,deletedAt,imagePath,dishType,description);
		}
		return menu;
	}

	
	@Override
	public void updateMenu(Menu menu) {
		
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);
			
			pstmt.setInt(1, menu.getRestaurant_id());
			pstmt.setString(2, menu.getItemName());
			pstmt.setFloat(3, menu.getPrice());
			pstmt.setInt(4, menu.getIs_available());
			pstmt.setString(5, menu.getCategory());
			pstmt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
			pstmt.setString(7, menu.getImagePath());
			pstmt.setString(8, menu.getDishType());
			pstmt.setString(9, menu.getDescription());
			pstmt.setInt(10, menu.getMenu_id());
			
			
			int res = pstmt.executeUpdate();
			System.out.println(res);
			
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
	}

	@Override
	public void deleteMenu(int menu_id) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(DELETE_QUERY);
			
			pstmt.setInt(1, menu_id);
			
			int result = pstmt.executeUpdate();
			System.out.println(result);
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<Menu> getAllMenu() {
		
		List<Menu> allMenu = new ArrayList<Menu>();
		
		Connection connection = DBConnection.getConnection();
		try {
			Statement stmt = connection.createStatement();
			ResultSet result = stmt.executeQuery(SELECT_ALL_QUERY);
			
			while(result.next()) {
				int menu_id = result.getInt(1);
				int restaurant_id = result.getInt(2);
				String itemName = result.getString(3);
				float price = result.getFloat(4);
				int is_available = result.getInt(5);
				String category = result.getString(6);
				Timestamp createdAt = result.getTimestamp(7);
				Timestamp updatedAt = result.getTimestamp(8);
				Timestamp deletedAt = result.getTimestamp(9);
				String imagePath = result.getString(10);
				String dishType = result.getString(11);
				String description = result.getString(12);
				
				Menu menu = new Menu(menu_id,restaurant_id,itemName,price,is_available,category,createdAt,updatedAt,deletedAt,imagePath,dishType,description);
				allMenu.add(menu);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return allMenu;
	}

	@Override
	public List<Menu> getMenusByRestaurantId(int restaurantId) {
        List<Menu> menus = new ArrayList<>();
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(MENU_BY_RESTAURANT_ID)) {

            ps.setInt(1, restaurantId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Menu menu = new Menu();
                    menu.setMenu_id(rs.getInt("menu_id"));
                    menu.setRestaurant_id(rs.getInt("restaurant_id"));
                    menu.setItemName(rs.getString("itemName"));
                    menu.setPrice(rs.getFloat("price"));
                    menu.setIs_available(rs.getInt("is_available"));
                    menu.setCategory(rs.getString("category"));
                    menu.setImagePath(rs.getString("imagePath"));
                    menu.setDishType(rs.getString("dishType"));
                    menu.setDescription(rs.getString("description"));

                    menus.add(menu);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return menus;
    }
	
	@Override
	public List<Integer> getRestaurantIdsByFoodCategory(String foodCategory) {

	    List<Integer> restaurantIds = new ArrayList<>();

	    String sql =
	        "SELECT DISTINCT restaurant_id FROM menu " +
	        "WHERE (LOWER(TRIM(category)) = LOWER(?) " +
	        "OR LOWER(itemName) LIKE LOWER(?)) " +
	        "AND is_available = 1 " +
	        "AND deletedAt IS NULL";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setString(1, foodCategory.trim());
	        ps.setString(2, "%" + foodCategory.trim() + "%");

	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                restaurantIds.add(rs.getInt("restaurant_id"));
	            }
	        }

	    } catch (SQLException e) {
	        throw new RuntimeException(
	            "Unable to find restaurants for food category: "
	                + foodCategory, e);
	    }

	    return restaurantIds;
	}
}
