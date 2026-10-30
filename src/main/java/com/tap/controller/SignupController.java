
package com.tap.controller;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import com.tap.model.User;
import com.tap.DAOImp.UserDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/Signup")
public class SignupController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
                          throws ServletException, IOException {

        // Get registration details.
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String address = req.getParameter("address");
        String phone = req.getParameter("phone");

        // Create User object.
        User user = new User();

        user.setName(name);
        user.setEmail(email);

        // Hash password using BCrypt.
        String hashedPassword =
                BCrypt.hashpw(password, BCrypt.gensalt());

        user.setPassword(hashedPassword);
        user.setAddress(address);
        user.setPhone(phone);
        user.setRole("user");

        UserDAOImpl dao = new UserDAOImpl();

        // Step 1: Register user in the database.
        boolean registrationSuccessful = dao.addUser(user);

        if (registrationSuccessful) {

            // Step 2: Retrieve the registered user.
            User registeredUser = dao.getUserByEmail(email);

            if (registeredUser != null) {

                // Step 3: Create authenticated session.
                HttpSession session = req.getSession(true);

                // Protect against session fixation.
                req.changeSessionId();

                // Do not store the password hash in the session.
                registeredUser.setPassword(null);

                // Step 4: Store the logged-in user.
                session.setAttribute("loggedInUser", registeredUser);

                // Step 5: Redirect to restaurants page.
                resp.sendRedirect(
                    req.getContextPath() + "/restaurants"
                );

                return;
            }
        }

        // Registration failed or user retrieval failed.
        resp.sendRedirect(req.getContextPath() + "/signin");
    }
}
