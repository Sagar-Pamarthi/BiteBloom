package com.tap.DAOImp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.OrdersDAO;
import com.tap.model.Orders;
import com.tap.util.DBConnection;

public class OrdersDAOImpl implements OrdersDAO {

    private static final String INSERT_QUERY =
            "INSERT INTO orders(user_id, restaurant_id, order_date, total_amount, status, payment_mode) VALUES(?,?,?,?,?,?)";

    private static final String SELECT_QUERY =
            "SELECT * FROM orders WHERE order_id = ?";

    private static final String UPDATE_QUERY =
            "UPDATE orders SET user_id = ?, restaurant_id = ?, total_amount = ?, status = ?, payment_mode = ? WHERE order_id = ?";

    private static final String DELETE_QUERY = "DELETE FROM orders WHERE order_id = ?";

    private static final String SELECT_ALL_QUERY = "SELECT * FROM orders";
    
    private static final String SELECT_BY_USER = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";


    @Override
    public int addOrder(Orders orders) {

        int generatedOrderId = 0;
        Connection connection = DBConnection.getConnection();

        try {
            PreparedStatement statement = connection.prepareStatement(INSERT_QUERY, Statement.RETURN_GENERATED_KEYS);

            statement.setInt(1, orders.getUser_id());
            statement.setInt(2, orders.getRestaurant_id());
            statement.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            statement.setFloat(4, orders.getTotal_amount());
            statement.setString(5, orders.getStatus());
            statement.setString(6, orders.getPayment_mode());

            statement.executeUpdate();

            try (ResultSet resultSet = statement.getGeneratedKeys()) {
                if (resultSet.next()) {
                    generatedOrderId = resultSet.getInt(1);
                    orders.setOrder_id(generatedOrderId);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return generatedOrderId;
    }

    @Override
    public Orders getOrder(int order_id) {
        Orders order = null;
        Connection connection = DBConnection.getConnection();

        try {
            PreparedStatement statement = connection.prepareStatement(SELECT_QUERY);
            statement.setInt(1, order_id);

            ResultSet resultSet = statement.executeQuery();
            order = extractOrderFromResultSet(resultSet);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return order;
    }

    public Orders extractOrderFromResultSet(ResultSet resultSet) throws SQLException {
        Orders orders = null;

        while (resultSet.next()) {
            int order_id = resultSet.getInt(1);
            int user_id = resultSet.getInt(2);
            int restaurant_id = resultSet.getInt(3);
            Timestamp order_date = resultSet.getTimestamp(4);
            float total_amount = resultSet.getFloat(5);
            String status = resultSet.getString(6);
            String payment_mode = resultSet.getString(7);

            orders = new Orders(order_id, user_id, restaurant_id, order_date, total_amount, status, payment_mode);
        }

        return orders;
    }

    @Override
    public void updateOrder(Orders orders) {

        Connection connection = DBConnection.getConnection();

        try {
            PreparedStatement statement = connection.prepareStatement(UPDATE_QUERY);

            statement.setInt(1, orders.getUser_id());
            statement.setInt(2, orders.getRestaurant_id());
            statement.setFloat(3, orders.getTotal_amount());
            statement.setString(4, orders.getStatus());
            statement.setString(5, orders.getPayment_mode());
            statement.setInt(6, orders.getOrder_id());

            int result = statement.executeUpdate();
            System.out.println(result);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrder(int order_id) {

        Connection connection = DBConnection.getConnection();

        try {
            PreparedStatement statement = connection.prepareStatement(DELETE_QUERY);
            statement.setInt(1, order_id);

            int result = statement.executeUpdate();
            System.out.println(result);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Orders> getAllOrders() {

        List<Orders> allOrders = new ArrayList<>();
        Connection connection = DBConnection.getConnection();

        try {
            Statement statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery(SELECT_ALL_QUERY);

            while (resultSet.next()) {
                int order_id = resultSet.getInt(1);
                int user_id = resultSet.getInt(2);
                int restaurant_id = resultSet.getInt(3);
                Timestamp order_date = resultSet.getTimestamp(4);
                float total_amount = resultSet.getFloat(5);
                String status = resultSet.getString(6);
                String payment_mode = resultSet.getString(7);

                Orders orders = new Orders(order_id, user_id, restaurant_id, order_date, total_amount, status, payment_mode);
                allOrders.add(orders);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return allOrders;
    }
    
    
    public List<Orders> getOrdersByUserId(int userId) {

        List<Orders> orders = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_BY_USER)) {

            pstmt.setInt(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {

                    Orders order = new Orders();

                    order.setOrder_id(rs.getInt("order_id"));
                    order.setUser_id(rs.getInt("user_id"));
                    order.setRestaurant_id(rs.getInt("restaurant_id"));
                    order.setOrder_date(rs.getTimestamp("order_date"));
                    order.setTotal_amount(rs.getFloat("total_amount"));
                    order.setStatus(rs.getString("status"));
                    order.setPayment_mode(rs.getString("payment_mode"));

                    orders.add(order);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }
}