package com.tap.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.tap.DAOImp.MenuDAOImpl;
import com.tap.DAOImp.OrderItemDAOImpl;
import com.tap.DAOImp.OrdersDAOImpl;
import com.tap.DAOImp.RestaurantDAOImpl;

import com.tap.model.Menu;
import com.tap.model.Order_item;
import com.tap.model.Orders;
import com.tap.model.Restaurant;
import com.tap.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/OrdersController")
public class OrdersController extends HttpServlet {


    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {


        HttpSession session = req.getSession(false);


        if(session == null || session.getAttribute("loggedInUser") == null) {

            resp.sendRedirect(req.getContextPath()+"/login.jsp");
            return;
        }


        User user = (User) session.getAttribute("loggedInUser");


        int userId = user.getUser_id();



        // Fetch Orders

        OrdersDAOImpl ordersDAO = new OrdersDAOImpl();

        List<Orders> orders =
                ordersDAO.getOrdersByUserId(userId);



        // Fetch Order Items

        OrderItemDAOImpl orderItemDAO =
                new OrderItemDAOImpl();


        Map<Integer,List<Order_item>> orderItemsMap =
                new HashMap<>();


        for(Orders order : orders) {


            List<Order_item> items =
                    orderItemDAO.getOrderItemsByOrderId(
                            order.getOrder_id()
                    );


            orderItemsMap.put(
                    order.getOrder_id(),
                    items
            );

        }



        // Fetch Restaurant Details

        RestaurantDAOImpl restaurantDAO =
                new RestaurantDAOImpl();


        Map<Integer,Restaurant> restaurantMap =
                new HashMap<>();


        for(Orders order : orders) {


            int restaurantId =
                    order.getRestaurant_id();


            if(!restaurantMap.containsKey(restaurantId)) {


                Restaurant restaurant =
                        restaurantDAO.getRestaurant(
                                restaurantId
                        );


                restaurantMap.put(
                        restaurantId,
                        restaurant
                );

            }

        }




        // Fetch Menu Details

        MenuDAOImpl menuDAO =
                new MenuDAOImpl();


        Map<Integer,Menu> menuMap =
                new HashMap<>();



        for(List<Order_item> items : orderItemsMap.values()) {


            for(Order_item item : items) {


                int menuId =
                        item.getMenu_id();



                if(!menuMap.containsKey(menuId)) {


                    Menu menu =
                            menuDAO.getMenu(menuId);



                    menuMap.put(
                            menuId,
                            menu
                    );

                }

            }

        }




        // Send data to JSP

        req.setAttribute("orders", orders);

        req.setAttribute(
                "orderItemsMap",
                orderItemsMap
        );


        req.setAttribute(
                "restaurantMap",
                restaurantMap
        );


        req.setAttribute(
                "menuMap",
                menuMap
        );



        RequestDispatcher rd =
                req.getRequestDispatcher(
                        "/orders.jsp"
                );


        rd.forward(req, resp);

    }



    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        doGet(req, resp);

    }

}