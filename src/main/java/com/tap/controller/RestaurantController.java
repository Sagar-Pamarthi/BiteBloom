package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.DAOImp.RestaurantDAOImpl;
import com.tap.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/restaurants")
public class RestaurantController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();

        String foodCategory = req.getParameter("foodCategory");
        String search = req.getParameter("q");

        if (foodCategory == null || foodCategory.isBlank()) {
            foodCategory = "all";
        }

        if (search == null) {
            search = "";
        }

        try {
            List<Restaurant> restaurants =
                    restaurantDAO.getRestaurantsByFoodCategoryAndSearch(
                            foodCategory, search);

            req.setAttribute("restaurants", restaurants);
            req.setAttribute("selectedFoodCategory", foodCategory);
            req.setAttribute("searchQuery", search);

            RequestDispatcher dispatcher =
                    req.getRequestDispatcher("/restaurants.jsp");

            dispatcher.forward(req, resp);

        } catch (RuntimeException e) {
            throw new ServletException(
                    "Unable to load restaurants.", e);
        }
    }
}