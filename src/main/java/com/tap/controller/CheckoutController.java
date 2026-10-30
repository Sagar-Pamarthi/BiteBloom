package com.tap.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.OrdersDAO;
import com.tap.DAO.OrderItemDAO;
import com.tap.DAO.UserDAO;
import com.tap.DAOImp.OrdersDAOImpl;
import com.tap.DAOImp.OrderItemDAOImpl;
import com.tap.DAOImp.UserDAOImpl;
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
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Cart cart = session == null ? null : (Cart) session.getAttribute("cart");
        User loggedInUser = session == null ? null : (User) session.getAttribute("loggedInUser");

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
        Cart cart = session == null ? null : (Cart) session.getAttribute("cart");
        User loggedInUser = session == null ? null : (User) session.getAttribute("loggedInUser");

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        if (loggedInUser == null) {
            req.getSession(true).setAttribute("checkoutMessage", "Please sign in before confirming your order.");
            resp.sendRedirect(req.getContextPath() + "/signin");
            return;
        }

        String action = trim(req.getParameter("action"));
        if ("saveAddress".equals(action)) {
            saveAddress(req, resp, session, cart, loggedInUser);
            return;
        }

        placeOrder(req, resp, session, cart, loggedInUser);
    }

    private void saveAddress(HttpServletRequest req, HttpServletResponse resp,
            HttpSession session, Cart cart, User loggedInUser)
            throws ServletException, IOException {
        String houseName = trim(req.getParameter("houseName"));
        String street = trim(req.getParameter("street"));
        String city = trim(req.getParameter("city"));
        String pincode = trim(req.getParameter("pincode"));
        String landmark = trim(req.getParameter("landmark"));
        String addressType = trim(req.getParameter("addressType"));

        keepAddressFormValues(req, houseName, street, city, pincode, landmark, addressType);

        if (houseName.isEmpty() || street.isEmpty() || city.isEmpty() || !pincode.matches("[0-9]{6}")) {
            forwardCheckoutError(req, resp, cart, loggedInUser,
                    "Enter house/flat, street/area, city and a valid 6-digit pincode.", true);
            return;
        }

        if (!"Home".equals(addressType) && !"Work".equals(addressType) && !"Other".equals(addressType)) {
            addressType = "Home";
        }

        List<String> addressParts = new ArrayList<>();
        addressParts.add(houseName);
        addressParts.add(street);
        if (!landmark.isEmpty()) {
            addressParts.add("Landmark: " + landmark);
        }
        addressParts.add(city + " - " + pincode);
        addressParts.add("(" + addressType + ")");
        String completeAddress = String.join(", ", addressParts);

        UserDAO userDAO = new UserDAOImpl();
        boolean saved = userDAO.updateAddress(loggedInUser.getUser_id(), completeAddress);
        if (!saved) {
            forwardCheckoutError(req, resp, cart, loggedInUser,
                    "We couldn't save your address. Please try again.", true);
            return;
        }

        // Keep the in-session user in sync with the database so the new address is shown immediately.
        loggedInUser.setAddress(completeAddress);
        session.setAttribute("loggedInUser", loggedInUser);
        session.setAttribute("addressSavedMessage", "Address saved successfully. Your current delivery address has been updated.");
        resp.sendRedirect(req.getContextPath() + "/checkout");
    }

    private void placeOrder(HttpServletRequest req, HttpServletResponse resp,
            HttpSession session, Cart cart, User loggedInUser)
            throws ServletException, IOException {
        String paymentMethod = trim(req.getParameter("paymentMethod"));
        // Online methods are disabled in the current UI and are not implemented in the backend.
        if (!"COD".equals(paymentMethod)) {
            forwardCheckoutError(req, resp, cart, loggedInUser,
                    "Only Cash on Delivery is available right now. Please select it to continue.", false);
            return;
        }

        String deliveryAddress = trim(req.getParameter("deliveryAddress"));
        if (deliveryAddress.isEmpty()) {
            deliveryAddress = loggedInUser.getAddress() == null ? "" : loggedInUser.getAddress().trim();
        }

        if (deliveryAddress.isEmpty()) {
            forwardCheckoutError(req, resp, cart, loggedInUser,
                    "Please save a delivery address before placing your order.", true);
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
            forwardCheckoutError(req, resp, cart, loggedInUser,
                    "Order could not be placed. Please try again.", false);
            return;
        }

        OrderItemDAO orderItemDAO = new OrderItemDAOImpl();
        for (CartItem cartItem : cart.getCartItems()) {
            if (cartItem == null || cartItem.getMenu() == null) {
                continue;
            }
            Order_item orderItem = new Order_item();
            orderItem.setOrder_id(generatedOrderId);
            orderItem.setMenu_id(cartItem.getMenu().getMenu_id());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setItem_total((float) cartItem.getSubTotal());
            orderItemDAO.addOrder_item(orderItem);
        }

        session.setAttribute("recentOrderId", generatedOrderId);
        session.setAttribute("recentOrderTotal", cart.getGrandTotal());
        session.setAttribute("recentDeliveryAddress", deliveryAddress);
        session.removeAttribute("cart");

        resp.sendRedirect(req.getContextPath() + "/orderConfirmed.jsp");
    }

    private void keepAddressFormValues(HttpServletRequest req, String houseName, String street,
            String city, String pincode, String landmark, String addressType) {
        req.setAttribute("addressFormHouseName", houseName);
        req.setAttribute("addressFormStreet", street);
        req.setAttribute("addressFormCity", city);
        req.setAttribute("addressFormPincode", pincode);
        req.setAttribute("addressFormLandmark", landmark);
        req.setAttribute("addressFormType", addressType);
    }

    private void forwardCheckoutError(HttpServletRequest req, HttpServletResponse resp,
            Cart cart, User loggedInUser, String message, boolean openAddressForm)
            throws ServletException, IOException {
        req.setAttribute("cart", cart);
        req.setAttribute("loggedInUser", loggedInUser);
        req.setAttribute("loginRequired", false);
        req.setAttribute("errorMessage", message);
        req.setAttribute("openAddressForm", openAddressForm);
        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
