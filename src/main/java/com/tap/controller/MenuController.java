package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.DAOImp.MenuDAOImpl;
import com.tap.DAOImp.RestaurantDAOImpl;
import com.tap.model.Menu;
import com.tap.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/menu")
public class MenuController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String restaurantIdParam = req.getParameter("restaurantId");

        if (restaurantIdParam == null || restaurantIdParam.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/restaurant");
            return;
        }

        int restaurantId = Integer.parseInt(restaurantIdParam);

        RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
        MenuDAOImpl menuDAO = new MenuDAOImpl();

        Restaurant restaurant = restaurantDAO.getRestaurant(restaurantId);
        List<Menu> menus = menuDAO.getMenusByRestaurantId(restaurantId);

        req.setAttribute("restaurant", restaurant);
        req.setAttribute("menus", menus);

        RequestDispatcher rd = req.getRequestDispatcher("/menu.jsp");
        rd.forward(req, resp);
    }
}