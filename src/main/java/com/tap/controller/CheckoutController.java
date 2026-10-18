package com.tap.controller;

import java.io.IOException;

import com.tap.DAO.OrdersDAO;
import com.tap.DAO.Order_itemDAO;
import com.tap.DAOImp.OrdersDAOImpl;
import com.tap.DAOImp.OrderItemDAOImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Order_item;
import com.tap.model.Orders;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {


	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		HttpSession session = req.getSession(false);

		Cart cart = null;
		User loggedInUser = null;

		if (session != null) {
			cart = (Cart) session.getAttribute("cart");
			loggedInUser = (User) session.getAttribute("loggedInUser");
		}

		if (cart == null || cart.isEmpty()) {
			resp.sendRedirect(req.getContextPath() + "/cart");
			return;
		}

		req.setAttribute("cart", cart);
		req.setAttribute("loggedInUser", loggedInUser);
		req.setAttribute("loginRequired", loggedInUser == null);

		req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		HttpSession session = req.getSession(false);

		Cart cart = null;
		User loggedInUser = null;

		if (session != null) {
			cart = (Cart) session.getAttribute("cart");
			loggedInUser = (User) session.getAttribute("loggedInUser");
		}

		if (cart == null || cart.isEmpty()) {
			resp.sendRedirect(req.getContextPath() + "/cart");
			return;
		}

		if (loggedInUser == null) {
			if (session != null) {
				session.setAttribute("checkoutMessage", "Please login before confirming the order.");
			}
			resp.sendRedirect(req.getContextPath() + "/login.jsp");
			return;
		}

		String deliveryAddress = req.getParameter("deliveryAddress");
		if (deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
			deliveryAddress = loggedInUser.getAddress();
		}

		if (deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
			req.setAttribute("errorMessage", "Please enter delivery address.");
			req.setAttribute("cart", cart);
			req.setAttribute("loggedInUser", loggedInUser);
			req.setAttribute("loginRequired", false);
			req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
			return;
		}

		Orders order = new Orders();
		order.setUser_id(loggedInUser.getUser_id());
		order.setRestaurant_id(cart.getRestaurantId());
		order.setTotal_amount((float) cart.getGrandTotal());
		order.setStatus("placed");
		order.setPayment_mode("cash");

		OrdersDAO ordersDAO = new OrdersDAOImpl();
		int generatedOrderId = ordersDAO.addOrder(order);

		if (generatedOrderId <= 0) {
			req.setAttribute("errorMessage", "Order could not be placed. Please try again.");
			req.setAttribute("cart", cart);
			req.setAttribute("loggedInUser", loggedInUser);
			req.setAttribute("loginRequired", false);
			req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
			return;
		}

		Order_itemDAO orderItemDAO = new OrderItemDAOImpl();

		for (CartItem cartItem : cart.getCartItems()) {
			Order_item orderItem = new Order_item();
			orderItem.setOrder_id(generatedOrderId);
			orderItem.setMenu_id(cartItem.getMenu().getMenu_id());
			orderItem.setQuantity(cartItem.getQuantity());
			orderItem.setItem_total((float) cartItem.getSubTotal());

			orderItemDAO.addOrder_item(orderItem);
		}

		if (session != null) {
			session.setAttribute("recentOrderId", generatedOrderId);
			session.setAttribute("recentOrderTotal", cart.getGrandTotal());
			session.setAttribute("recentDeliveryAddress", deliveryAddress);
			session.removeAttribute("cart");
		}

		resp.sendRedirect(req.getContextPath() + "/orderConfirmed.jsp");
	}
}