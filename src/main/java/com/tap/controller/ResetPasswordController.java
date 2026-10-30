package com.tap.controller;

import java.io.IOException;
import java.sql.SQLException;

import org.mindrot.jbcrypt.BCrypt;

import com.tap.DAO.PasswordResetDAO;
import com.tap.DAOImp.PasswordResetDAOImpl;
import com.tap.util.PasswordResetOtpUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/reset-password")
public class ResetPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String GENERIC_CODE_ERROR = "The code is incorrect, expired, or no longer usable. "
            + "Check the code or request a new one.";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String email = session == null ? null : (String) session.getAttribute("pendingPasswordResetEmail");
        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }
        if (session.getAttribute("passwordResetNotice") != null) {
            request.setAttribute("resetNotice", session.getAttribute("passwordResetNotice"));
            session.removeAttribute("passwordResetNotice");
        }
        request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        String email = session == null ? null : (String) session.getAttribute("pendingPasswordResetEmail");
        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        String otp = request.getParameter("otp");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        if (otp == null || !otp.matches("[0-9]{6}")) {
            showError(request, response, "Enter the six-digit code from your email.");
            return;
        }
        if (password == null || password.length() < 8) {
            showError(request, response, "Use a password with at least 8 characters.");
            return;
        }
        if (confirmPassword == null || !password.equals(confirmPassword)) {
            showError(request, response, "The new passwords do not match.");
            return;
        }

        try {
            PasswordResetDAO dao = new PasswordResetDAOImpl();
            String otpHash = PasswordResetOtpUtil.hashOtp(email, otp);
            if (!dao.verifyOtp(email, otpHash)) {
                showError(request, response, GENERIC_CODE_ERROR);
                return;
            }

            String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt(12));
            // ResetPasswordDAO revalidates the code and consumes it in the password-update transaction.
            if (dao.resetPassword(email, otpHash, passwordHash)) {
                session.removeAttribute("pendingPasswordResetEmail");
                session.removeAttribute("passwordResetNotice");
                response.sendRedirect(request.getContextPath() + "/signin?reset=success");
                return;
            }
            showError(request, response, GENERIC_CODE_ERROR);
        } catch (SQLException exception) {
            getServletContext().log("Password reset OTP transaction failed.", exception);
            showError(request, response, "We could not reset your password right now. Please try again later.");
        } catch (IllegalStateException exception) {
            getServletContext().log("Password reset OTP configuration is incomplete.", exception);
            showError(request, response, "Password reset is temporarily unavailable. Please try again later.");
        }
    }

    private void showError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("resetError", message);
        request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
    }
}
