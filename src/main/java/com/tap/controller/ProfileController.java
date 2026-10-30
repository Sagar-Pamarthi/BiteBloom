package com.tap.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Locale;
import java.util.regex.Pattern;

import com.tap.DAOImp.UserDAOImpl;
import com.tap.model.User;
import com.tap.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?(?:\\.[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?)+$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9+() .-]{7,20}$");
    private static final String ORDER_COUNT_SQL = "SELECT COUNT(*) FROM orders WHERE user_id = ?";

    private final UserDAOImpl userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User sessionUser = session == null ? null : (User) session.getAttribute("loggedInUser");
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }

        // Load the latest saved values from the database, not just the old session copy.
        User currentUser = sessionUser;
        if (sessionUser.getEmail() != null && !sessionUser.getEmail().trim().isEmpty()) {
            User databaseUser = userDAO.getUserByEmail(sessionUser.getEmail().trim());
            if (databaseUser != null) {
                currentUser = databaseUser;
                session.setAttribute("loggedInUser", currentUser);
            }
        }

        String editField = safeField(request.getParameter("edit"));
        request.setAttribute("profileUser", currentUser);
        request.setAttribute("editField", editField);
        request.setAttribute("totalOrderCount", countOrders(currentUser.getUser_id()));
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String action = trim(request.getParameter("action"));

        if ("signout".equals(action)) {
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/restaurants");
            return;
        }

        User loggedInUser = session == null ? null : (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }

        if (!"updateProfileField".equals(action)) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        String field = safeField(request.getParameter("field"));
        String value = trim(request.getParameter("value"));
        if (field.isEmpty() || !isValidValue(field, value)) {
            response.sendRedirect(request.getContextPath() + "/profile?edit=" + field + "&error=invalid");
            return;
        }

        boolean saved = userDAO.updateProfileField(loggedInUser.getUser_id(), field, value);
        if (!saved) {
            response.sendRedirect(request.getContextPath() + "/profile?edit=" + field + "&error=save");
            return;
        }

        // Keep the authenticated session synchronized with the database immediately.
        switch (field) {
            case "name":
                loggedInUser.setName(value);
                break;
            case "email":
                loggedInUser.setEmail(value);
                break;
            case "phone":
                loggedInUser.setPhone(value);
                break;
            case "address":
                loggedInUser.setAddress(value);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
        }
        session.setAttribute("loggedInUser", loggedInUser);
        response.sendRedirect(request.getContextPath() + "/profile?updated=true");
    }

    private int countOrders(int userId) {
        try (Connection connection = DBConnection.getConnection()) {
            if (connection == null) return -1;
            try (PreparedStatement statement = connection.prepareStatement(ORDER_COUNT_SQL)) {
                statement.setInt(1, userId);
                try (ResultSet result = statement.executeQuery()) {
                    return result.next() ? result.getInt(1) : 0;
                }
            }
        } catch (SQLException exception) {
            // The profile remains usable if the database has a different orders-table schema.
            getServletContext().log("Unable to count orders for profile page. Check ORDER_COUNT_SQL.", exception);
            return -1;
        }
    }

    private String safeField(String field) {
        if (field == null) return "";
        String normalized = field.trim().toLowerCase(Locale.ROOT);
        return ("name".equals(normalized) || "email".equals(normalized)
                || "phone".equals(normalized) || "address".equals(normalized)) ? normalized : "";
    }

    private boolean isValidValue(String field, String value) {
        if (value == null || value.isEmpty()) return false;
        switch (field) {
            case "name":
                return value.length() >= 2 && value.length() <= 100;
            case "email":
                return value.length() <= 254 && EMAIL_PATTERN.matcher(value).matches();
            case "phone":
                return PHONE_PATTERN.matcher(value).matches();
            case "address":
                return value.length() <= 500;
            default:
                return false;
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
