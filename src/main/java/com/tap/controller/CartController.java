package com.tap.controller;

import java.io.IOException;

import com.tap.DAO.MenuDAO;
import com.tap.DAOImp.MenuDAOImpl;
import com.tap.model.Cart;
import com.tap.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String source = req.getParameter("source");
        String restaurantIdParam = req.getParameter("restaurantId");
        String menuIdParam = req.getParameter("menuId");

        HttpSession session = req.getSession();

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        if ("add".equals(action)) {
            handleAdd(req, resp, session, cart, menuIdParam, restaurantIdParam);
            return;
        }

        if ("increase".equals(action)) {
            handleIncrease(req, resp, session, cart, menuIdParam, source, restaurantIdParam);
            return;
        }

        if ("decrease".equals(action)) {
            handleDecrease(req, resp, session, cart, menuIdParam, source, restaurantIdParam);
            return;
        }

        if ("remove".equals(action)) {
            handleRemove(req, resp, session, cart, menuIdParam, source, restaurantIdParam);
            return;
        }

        if ("clear".equals(action)) {
            cart.clearCart();
            session.setAttribute("cart", cart);
            redirectAfterAction(req, resp, source, restaurantIdParam);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        req.setAttribute("cart", cart);
        req.getRequestDispatcher("/cart.jsp").forward(req, resp);
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp, HttpSession session,
                           Cart cart, String menuIdParam, String restaurantIdParam) throws IOException {

        if (menuIdParam == null || restaurantIdParam == null) {
            resp.sendRedirect(req.getContextPath() + "/restaurant");
            return;
        }

        int menuId = Integer.parseInt(menuIdParam);

        MenuDAO menuDao = new MenuDAOImpl();
        Menu menu = menuDao.getMenu(menuId);

        if (menu == null || menu.getIs_available() != 1) {
            resp.sendRedirect(req.getContextPath() + "/menu?restaurantId=" + restaurantIdParam + "&error=menuUnavailable");
            return;
        }

        boolean added = cart.addItem(menu);

        if (added) {
            session.setAttribute("cart", cart);
            resp.sendRedirect(req.getContextPath() + "/menu?restaurantId=" + restaurantIdParam);
        } else {
            resp.sendRedirect(req.getContextPath() + "/menu?restaurantId=" + restaurantIdParam + "&cartError=differentRestaurant");
        }
    }

    private void handleIncrease(HttpServletRequest req, HttpServletResponse resp, HttpSession session,
                                Cart cart, String menuIdParam, String source, String restaurantIdParam)
            throws IOException {

        if (menuIdParam != null && cart.getItems() != null) {
            int menuId = Integer.parseInt(menuIdParam);

            if (cart.getItems().containsKey(menuId)) {
                int currentQty = cart.getItems().get(menuId).getQuantity();
                cart.updateQuantity(menuId, currentQty + 1);
                session.setAttribute("cart", cart);
            }
        }

        redirectAfterAction(req, resp, source, restaurantIdParam);
    }

    private void handleDecrease(HttpServletRequest req, HttpServletResponse resp, HttpSession session,
                                Cart cart, String menuIdParam, String source, String restaurantIdParam)
            throws IOException {

        if (menuIdParam != null && cart.getItems() != null) {
            int menuId = Integer.parseInt(menuIdParam);

            if (cart.getItems().containsKey(menuId)) {
                int currentQty = cart.getItems().get(menuId).getQuantity();
                cart.updateQuantity(menuId, currentQty - 1);
                session.setAttribute("cart", cart);
            }
        }

        redirectAfterAction(req, resp, source, restaurantIdParam);
    }

    private void handleRemove(HttpServletRequest req, HttpServletResponse resp, HttpSession session,
                              Cart cart, String menuIdParam, String source, String restaurantIdParam)
            throws IOException {

        if (menuIdParam != null) {
            int menuId = Integer.parseInt(menuIdParam);
            cart.removeItem(menuId);
            session.setAttribute("cart", cart);
        }

        redirectAfterAction(req, resp, source, restaurantIdParam);
    }

    private void redirectAfterAction(HttpServletRequest req, HttpServletResponse resp, String source, String restaurantIdParam)
            throws IOException {

        if ("menu".equals(source) && restaurantIdParam != null && !restaurantIdParam.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/menu?restaurantId=" + restaurantIdParam);
        } else {
            resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }
}