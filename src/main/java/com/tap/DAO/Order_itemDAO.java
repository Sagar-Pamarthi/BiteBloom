package com.tap.DAO;

import java.util.List;

import com.tap.model.Order_item;

public interface Order_itemDAO {

	void addOrder_item(Order_item order_item);
	Order_item getOrderItem(int orderitem_id);
	void updateOrder_item(Order_item order_item);
	void deleteOrder_item(int orderitem_id);
	List<Order_item> getAllOrder_item();
	List<Order_item> getOrderItemsByOrderId(int orderId);
}
