package com.tap.DAO;

import java.util.List;

import com.tap.model.Orders;

public interface OrdersDAO {

    int addOrder(Orders orders);

    Orders getOrder(int order_id);

    void updateOrder(Orders orders);

    void deleteOrder(int order_id);

    List<Orders> getAllOrders();
    
    List<Orders> getOrdersByUserId(int userId);
}