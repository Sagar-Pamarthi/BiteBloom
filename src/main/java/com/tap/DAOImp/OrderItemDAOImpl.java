package com.tap.DAOImp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.OrderItemDAO;
import com.tap.model.Order_item;
import com.tap.util.DBConnection;

public class OrderItemDAOImpl implements OrderItemDAO{

	private static final String INSERT_QUERY = "INSERT INTO order_item(order_id, menu_id, quantity, item_total) VALUES(?,?,?,?)";
	
	private static final String SELECT_QUERY = "SELECT * FROM order_item WHERE orderitem_id = ?";
	
	private static final String UPDATE_QUERY = "UPDATE order_item SET order_id = ?, menu_id = ?, quantity = ?,"
			+ "item_total = ? WHERE orderitem_id = ?";
	
	private static final String DELETE_QUERY = "DELETE FROM order_item WHERE orderitem_id = ?";
	
	private static final String SELECT_ALL_QUERY = "SELECT * FROM order_item";
	
	private static final String SELECT_BY_ORDER_ID = "SELECT * FROM order_item WHERE order_id = ?";
	
	@Override
	public void addOrder_item(Order_item order_item) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
			pstmt.setInt(1, order_item.getOrder_id());
			pstmt.setInt(2, order_item.getMenu_id());
			pstmt.setInt(3, order_item.getQuantity());
			pstmt.setFloat(4, order_item.getItem_total());
			
			int res = pstmt.executeUpdate();
			System.out.println(res);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	
	}

	@Override
	public Order_item getOrderItem(int orderitem_id) {
		Order_item order_item = null;
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(SELECT_QUERY);
			
			pstmt.setInt(1, orderitem_id);
			
			ResultSet resultSet = pstmt.executeQuery();
			order_item = extractOrderItemFromResultSet(resultSet);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return order_item;
	}

	public Order_item extractOrderItemFromResultSet(ResultSet resultSet) throws SQLException {
		Order_item order_item = null;
		while(resultSet.next()) {
			int orderitem_id = resultSet.getInt(1);
			int order_id = resultSet.getInt(2);
			int menu_id = resultSet.getInt(3);
			int quantity = resultSet.getInt(4);
			float item_total = resultSet.getFloat(5);
			
			order_item = new Order_item(orderitem_id,order_id,menu_id,quantity,item_total);
		}
		return order_item;
	}

	@Override
	public void updateOrder_item(Order_item order_item) {
	
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);
			pstmt.setInt(1, order_item.getOrder_id());
			pstmt.setInt(2, order_item.getMenu_id());
			pstmt.setInt(3, order_item.getQuantity());
			pstmt.setFloat(4, order_item.getItem_total());
			pstmt.setInt(5, order_item.getOrderitem_id());
			
			int res = pstmt.executeUpdate();
			System.out.println(res);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public void deleteOrder_item(int orderitem_id) {

		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(DELETE_QUERY);
			
			pstmt.setInt(1, orderitem_id);
			int res = pstmt.executeUpdate();
			System.out.println(res);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<Order_item> getAllOrder_item() {
		
		List<Order_item> allOrder_items = new ArrayList<Order_item>();
		
		Connection connection = DBConnection.getConnection();
		try {
			Statement stmt = connection.createStatement();
			
			ResultSet resultSet = stmt.executeQuery(SELECT_ALL_QUERY);
		
			while(resultSet.next()) {
				int orderitem_id = resultSet.getInt(1);
				int order_id = resultSet.getInt(2);
				int menu_id = resultSet.getInt(3);
				int quantity = resultSet.getInt(4);
				float item_total = resultSet.getFloat(5);
				
				Order_item order_item = new Order_item(orderitem_id,order_id,menu_id,quantity,item_total);
				allOrder_items.add(order_item);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return allOrder_items;
	}
	
	@Override
	public List<Order_item> getOrderItemsByOrderId(int orderId) {

	    List<Order_item> orderItems = new ArrayList<>();



	    try (Connection connection = DBConnection.getConnection();
	         PreparedStatement pstmt = connection.prepareStatement(SELECT_BY_ORDER_ID)) {

	        pstmt.setInt(1, orderId);

	        try (ResultSet rs = pstmt.executeQuery()) {

	            while (rs.next()) {

	                Order_item orderItem = new Order_item();

	                orderItem.setOrderitem_id(
	                        rs.getInt("orderitem_id"));

	                orderItem.setOrder_id(
	                        rs.getInt("order_id"));

	                orderItem.setMenu_id(
	                        rs.getInt("menu_id"));

	                orderItem.setQuantity(
	                        rs.getInt("quantity"));

	                orderItem.setItem_total(
	                        rs.getFloat("item_total"));

	                orderItems.add(orderItem);
	            }
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return orderItems;
	}
	
}
