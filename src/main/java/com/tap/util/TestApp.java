package com.tap.util;

import java.sql.Connection;
import java.sql.Timestamp;
import java.util.List;

import java.util.Scanner;

import com.tap.DAOImp.MenuDAOImpl;
import com.tap.DAOImp.OrderItemDAOImpl;
import com.tap.DAOImp.OrdersDAOImpl;
import com.tap.DAOImp.RestaurantDAOImpl;
import com.tap.DAOImp.UserDAOImpl;
import com.tap.model.Menu;
import com.tap.model.Order_item;
import com.tap.model.Orders;
import com.tap.model.Restaurant;
import com.tap.model.User;

public class TestApp {
	 
	
	public static void main(String[] args) {
		Scanner scan = new Scanner(System.in);
	
		UserDAOImpl udao = new UserDAOImpl();
		
		
		//Insert QUERY EXECUTION
		
//		System.out.println("Enter user Name");
//		String name = scan.next();
//		System.out.println("Enter Email");
//		String email = scan.next();
//		System.out.println("Enter password");
//		String password = scan.next();
//		System.out.println("Enter address");
//		String address = scan.next();
//		System.out.println("Enter phone");
//		String phone = scan.next();
//		System.out.println("Enter Role");
//		String role = scan.next();
		
//		User u = new User(name, email, password, address, phone, role);
//		udao.addUser(u);
//		System.out.println(u);
		
		
		
		//GET USER(SELECT) QUERY
		
//		System.out.println("Enter email");
//		String email = scan.nextLine();
//		System.out.println("Enter password");
//		String password = scan.nextLine();
//		
//		User user = udao.getUser(email, password);
//		System.out.println(user);
		
		
		
		//UPDATE QUERY EXECUTION
		
//		System.out.println("Enter updating user_id ");
//		int user_id = scan.nextInt();
//		User user = udao.getUser(user_id);
//		System.out.println(user);
//		
//		System.out.println("Enter the choice you want to update... 1 = name, 2 = email, 3 = password, 4 = address, 5 = phone, 6 = role");
//		
//		int choice = scan.nextInt();
//		scan.nextLine();
//		
//		switch (choice) {
//			
//		case 1:
//			System.out.println("Enter new Name: ");
//			String name = scan.nextLine();
//			user.setName(name);
//			System.out.println("Name updated");
//            break;
//          
//		case 2:
//			System.out.println("Enter new email: ");
//			String email = scan.next();
//			user.setEmail(email);
//			System.out.println("Email updated");
//			break;
//			
//		case 3:
//			System.out.println("Enter new Password: ");
//			String password = scan.next();
//			user.setPassword(password);
//			System.out.println("Password Updated");
//			break;
//			
//		case 4:
//			System.out.println("Enter new address: ");
//			String address = scan.nextLine();
//			user.setAddress(address);
//			System.out.println("Address Updated");
//			break;
//			
//		case 5:
//			System.out.println("Enter new Phone: ");
//			String phone = scan.next();
//			user.setPhone(phone);
//			System.out.println("Phone Updated");
//			break;
//			
//		case 6:
//			System.out.println("Enter new Role: ");
//			String role = scan.next();
//			user.setRole(role);
//			System.out.println("Role Updated");
//			break;
//			
//		default:
//            System.out.println("Invalid choice.");	
//		}
//		udao.updateUser(user);
//		System.out.println("User updated successfully.");
				
		
		
		//DELETING USER QUERY
		
//		System.out.println("Enter deleting user_id");
//		int user_id = scan.nextInt();
//		
//		User user = new User();
//		udao.deleteUser(user_id);
//		System.out.println(user);
		
		
		//Get All Users
		
//		List<User> allUsers = udao.getAllUsers();
//		for(User u: allUsers) {
//			System.out.println(u);
//		}
		
		
//		_______________________________________________________________________________________
		
		
						// Restaurant
		
		RestaurantDAOImpl rdao = new RestaurantDAOImpl();
		
		//Insert QUERY EXECUTION

//		System.out.println("Enter Restaurant Name");
//		String name = scan.nextLine();
//		System.out.println("Enter Cuisine_Type");
//		String cuisine_type = scan.nextLine();
//		System.out.println("Enter delivery time");
//		int delivery_time = scan.nextInt();
//		scan.nextLine();
//		System.out.println("Enter address");
//		String address = scan.nextLine();
//		System.out.println("Enter rating");
//		float rating = scan.nextFloat();
//		System.out.println("Restaurant active ?");
//		boolean is_active = scan.nextBoolean();
//
//		Restaurant restaurant = new Restaurant(name, cuisine_type, delivery_time, address, rating, is_active);
//		rdao.addRestaurant(restaurant);
//		System.out.println(restaurant);
		
		
		
		
		//Get Restaurant Execution(SELECT)
		
//		System.out.println("Enter Restaurant id");
//		int restaurant = scan.nextInt();
//		
//		Restaurant result = rdao.getRestaurant(restaurant);
//		System.out.println(result);
		
		
		
		// Update Restaurant
		
//		System.out.println("Enter the Updating Restaurant ID");
//		int restaurant_id = scan.nextInt();
//		Restaurant restaurant = rdao.getRestaurant(restaurant_id);
//		System.out.println(restaurant);
//
//		System.out.println("Enter the choice you want to update... 1 = name, 2 = cuisine_type, 3 = delivery_time, 4 = address, 5 = rating, 6 = is_active");
//		
//		int choice = scan.nextInt();
//		scan.nextLine();
//		
//		switch (choice) {
//		
//		case 1:
//			System.out.println("Enter new name of Restaurant");
//			String name = scan.nextLine();
//			restaurant.setName(name);
//			System.out.println("Name Updated");
//			break;
//		
//		case 2:
//			System.out.println("Enter new cuisine type of Restaurant");
//			String cuisine = scan.nextLine();
//			restaurant.setCuisine_type(cuisine);
//			System.out.println("Cuisine type Updated");
//			break;
//			
//		case 3:
//			System.out.println("Enter new Delivery TIme of Restaurant");
//			int delivery_time = scan.nextInt();
//			restaurant.setDelivery_time(delivery_time);
//			System.out.println("delivery time Updated");
//			break;
//			
//		case 4:
//			System.out.println("Enter new Address of Restaurant");
//			String address = scan.nextLine();
//			restaurant.setAddress(address);
//			System.out.println("Address Updated");
//			break;
//			
//		case 5:
//			System.out.println("Enter new Rating of Restaurant");
//			float rating = scan.nextFloat();
//			restaurant.setRating(rating);
//			System.out.println("Rating Updated");
//			break;
//			
//		case 6:
//			System.out.println("Enter Status of Restaurant i.e Active or not ?");
//			boolean is_active = scan.nextBoolean();
//			restaurant.setIs_active(is_active);
//			System.out.println("Status Updated");
//			break;
//			
//		default:
//			System.out.println("Invalid Choice... Select valid one");
//		}
//		rdao.updateRestaurant(restaurant);
//		System.out.println("Restaurant Updated Successfully !");
		
		
			// Delete Restaurant
		
//		System.out.println("Enter deleting restaurant id");
//		int restaurant_id = scan.nextInt();
//		
//		rdao.deleteRestaurant(restaurant_id);
//		System.out.println("Restaurant deleted Successfully !");
		
		
			// Get ALL Restaurants
		
//		List<Restaurant> allRestaurants = rdao.getAllRestaurants();
//		
//		for(Restaurant r :allRestaurants) {
//			System.out.println(r);
//		}
		
		
//		___________________________________________________________________________________________________________________
		
		
												// Menu Table
		
		MenuDAOImpl mdao = new MenuDAOImpl();
		
		
					// Insert Menu
		
//		System.out.println("Enter Restaurant id");
//		int restaurant_id = scan.nextInt();
//		scan.nextLine();
//		System.out.println("Enter description");
//		String description = scan.nextLine();
//		System.out.println("Enter Price");
//		float price = scan.nextFloat();
//		System.out.println("Enter availability status (0 or 1)");
//		int is_available = scan.nextInt();
//		scan.nextLine();
//		System.out.println("Enter category");
//		String category = scan.nextLine();
//		
//		
//		Menu menu = new Menu(restaurant_id,description,price,is_available,category);
//		mdao.addMenu(menu);
//		System.out.println(menu);
		
		
		
					// Get Menu
		
//		System.out.println("Enter menu id");
//		int menu_id = scan.nextInt();
//		
//		Menu menu = mdao.getMenu(menu_id);
//		System.out.println(menu);
		
		
		
					// Update Menu
		
//		System.out.println("Enter updating menu_id");
//		int menu_id = scan.nextInt();
//		Menu menu = mdao.getMenu(menu_id);
//		System.out.println(menu);
//		
//		System.out.println("ENter the choice You want to update... 1 = restaurant_id, 2 = description, 3 = price, 4 = is_available, 5 = category");
//		int choice = scan.nextInt();
//		scan.nextLine();
//		switch (choice) {
//		
//		case 1:
//			System.out.println("Enter new restaurant ID");
//			int restaurant_id = scan.nextInt();
//			menu.setRestaurant_id(restaurant_id);
//			System.out.println("Restaurant ID updated");
//			break;
//			
//		case 2:
//			System.out.println("Enter new description");
//			String descriptin = scan.nextLine();
//			menu.setDescription(descriptin);
//			System.out.println("Description updated");
//			break;
//		
//		case 3:
//			System.out.println("Enter new price");
//			int price = scan.nextInt();
//			menu.setPrice(price);
//			System.out.println("Price updated");
//			break;
//			
//		case 4:
//			System.out.println("Enter availability(0 or 1)");
//			int is_available = scan.nextInt();
//			menu.setIs_available(is_available);
//			System.out.println("availability updated");
//			break;
//			
//		case 5:
//			System.out.println("Enter Category");
//			String category = scan.nextLine();
//			menu.setCategory(category);
//			System.out.println("Category updated");
//			break;
//			
//		default:
//			System.out.println("Invalid choice");
//		}
//		mdao.updateMenu(menu);
//		System.out.println("Menu Updated Successfully!");
		
		
		
				// delete menu
		
//		System.out.println("Enter deleting menu id");
//		int menu_id = scan.nextInt();
//		mdao.deleteMenu(menu_id);
//		System.out.println("Menu deleted successfully!");
		
		
				// get all menu
		
//		List<Menu> allmenu = mdao.getAllMenu();
//		for(Menu menu : allmenu) {
//			System.out.println(menu);
//		}
		
//		_______________________________________________________________________________________________________________________
		
		
		
							// Orders Table Execution part
		
		OrdersDAOImpl odao = new OrdersDAOImpl();
		
		// Insert query
		
//		System.out.println("Enter user_id");
//		int user_id = scan.nextInt();
//		System.out.println("Enter restaurant id");
//		int restaurant_id = scan.nextInt();
//		System.out.println("Enter total amount");
//		float total_amount = scan.nextFloat();
//		System.out.println("Enter order status");
//		String status = scan.next();
//		System.out.println("Enter payment mode");
//		String payment_mode = scan.next();
//		
//		Orders orders = new Orders(user_id,restaurant_id,total_amount,status,payment_mode);
//		odao.addOrder(orders);
//		System.out.println(orders);
		
		
		
				// select query 
		
		
//		System.out.println("Enter fetching order id");
//		int order_id = scan.nextInt();
//		
//		Orders order = odao.getOrder(order_id);
//		System.out.println(order);
		
		
				// update query
		
//		System.out.println("Enter updating order_id");
//		int order_id = scan.nextInt();
//		Orders order = odao.getOrder(order_id);
//		System.out.println(order);
//		
//		System.out.println("Enter the choice you want to update....... 1=user_id, 2=restaurant_id, 3=total_amount, 4=status, 5=payment_mode");
//		
//		int choice = scan.nextInt();
//		scan.nextLine();
//		switch (choice) {
//		
//		case 1:
//			System.out.println("Enter new user_id");
//			int user_id = scan.nextInt();
//			order.setUser_id(user_id);
//			System.out.println("user id updated");
//			break;
//		case 2:
//			System.out.println("Enter new restaurant id");
//			int restaurant_id = scan.nextInt();
//			order.setRestaurant_id(restaurant_id);
//			System.out.println("restaurant_id updated");
//			break;
//		case 3:
//			System.out.println("Enter total_amount");
//			float total_amount = scan.nextFloat();
//			order.setTotal_amount(total_amount);
//			System.out.println("Total amount updated");
//			break;
//		case 4:
//			System.out.println("Enter new status of order");
//			String status = scan.nextLine();
//			order.setStatus(status);
//			System.out.println("status updated");
//			break;
//		case 5:
//			System.out.println("Enter new payment mode");
//			String payment_mode = scan.next();
//			order.setPayment_mode(payment_mode);
//			System.out.println("payment_mode updated");
//			break;
//		default:
//			System.out.println("Invalid choice");
//		}
//		odao.updateOrder(order);
//		System.out.println("Order updated successfully!!");
		
		
		
					// delete query
		
//		System.out.println("Enter deleting order_id");
//		int order_id = scan.nextInt();
//		odao.deleteOrder(order_id);
//		System.out.println("order deleted successfully!!");
		
					
		
					// get all orders 
		
//		List<Orders> allOrders = odao.getAllOrders();
//		for(Orders orders : allOrders) {
//			System.out.println(orders);
//		}
		
		
		
//		_________________________________________________________________________________________________________________
		
		
					// Order_item table execution
		
		OrderItemDAOImpl oidao = new OrderItemDAOImpl();
			
				// INSERT Query
		
//		System.out.println("Enter order_id");
//		int order_id = scan.nextInt();
//		System.out.println("Enter menu_id");
//		int menu_id = scan.nextInt();
//		System.out.println("Enter quantity");
//		int quantity = scan.nextInt();
//		System.out.println("Enter item total amount");
//		float total_amount = scan.nextFloat();
//				
//		Order_item order_item = new Order_item(order_id,menu_id,quantity,total_amount);
//		oidao.addOrder_item(order_item);
//		System.out.println("Order item added successfully!!");
		
		
			// SELECT QUERY
		
//		System.out.println("Enter order_item id");
//		int orderitem_id = scan.nextInt();
//		Order_item order_item = oidao.getOrderItem(orderitem_id);
//		System.out.println(order_item);
		
		
			// update query
		
//		Order_item order_item = oidao.getOrderItem(2);
//		System.out.println(order_item.getItem_total());
//		
//		order_item.setItem_total(1200);
//		System.out.println(order_item.getItem_total());
//		
//		oidao.updateOrder_item(order_item);
//		System.out.println("Updated");
		
		
		
			// delete query
		
//		System.out.println("Enter deleting order item id ");
//		int orderitem_id = scan.nextInt();
//		
//		oidao.deleteOrder_item(orderitem_id);
//		System.out.println("Order item Deleted");
		
		
			// get all order_items
		
//		List<Order_item> allOrder_items = oidao.getAllOrder_item();
//		for(Order_item order_item : allOrder_items) {
//			System.out.println(order_item);
//		}
		
		
		
	}
}
