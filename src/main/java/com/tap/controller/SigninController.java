package com.tap.controller;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import com.tap.DAOImp.UserDAOImpl;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/signin")
public class SigninController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("success".equals(request.getParameter("reset"))) {
            request.setAttribute("resetSuccess", "Your password has been reset. You can now sign in.");
        }
        request.getRequestDispatcher("/signin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User user = (email == null || email.trim().isEmpty())
                    ? null : new UserDAOImpl().getUserByEmail(email.trim());
            if (user != null && password != null && user.getPassword() != null
                    && BCrypt.checkpw(password, user.getPassword())) {
                HttpSession session = request.getSession();
                session.setAttribute("loggedInUser", user);
                response.sendRedirect(request.getContextPath() + "/restaurants");
                return;
            }
        } catch (RuntimeException exception) {
            getServletContext().log("Sign-in request failed.", exception);
        }

        request.setAttribute("loginError", "Invalid email or password, try again.");
        request.getRequestDispatcher("/signin.jsp").forward(request, response);
    }
}
