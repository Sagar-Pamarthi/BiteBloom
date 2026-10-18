package com.tap.controller;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import com.tap.DAO.UserDAO;
import com.tap.DAOImp.UserDAOImpl;
import com.tap.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/signin")
public class SigninController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        UserDAO userDao = new UserDAOImpl();

        User user = userDao.getUserByEmail(email);

        if (user != null && BCrypt.checkpw(password, user.getPassword())) {

            HttpSession session = req.getSession();

            session.setAttribute("loggedInUser", user);

            resp.sendRedirect(
                    req.getContextPath() + "/restaurants"
            );

        } else {

            req.setAttribute(
                    "loginError",
                    "Invalid email or password, try again."
            );

            RequestDispatcher rd = req.getRequestDispatcher("signin.jsp");
            
            rd.forward(req, resp);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        RequestDispatcher rd = req.getRequestDispatcher("/signin.jsp");
        rd.forward(req, resp);
    }
}