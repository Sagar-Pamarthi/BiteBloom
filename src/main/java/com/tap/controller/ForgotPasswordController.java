package com.tap.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.Instant;

import com.tap.DAO.PasswordResetDAO;
import com.tap.DAOImp.PasswordResetDAOImpl;
import com.tap.util.PasswordResetOtpUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/forgot-password")
public class ForgotPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int OTP_EXPIRY_MINUTES = 5;
    private static final String GENERIC_NOTICE = "If an account exists for that email, a six-digit code has been sent. "
            + "If you requested a code recently, wait 60 seconds before requesting another.";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String submittedEmail = request.getParameter("email");
        if (submittedEmail == null || submittedEmail.trim().isEmpty() || submittedEmail.trim().length() > 254) {
            request.setAttribute("formError", "Enter a valid email address.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }
        final String email = submittedEmail.trim();
        HttpSession session = request.getSession(true);
        session.setAttribute("pendingPasswordResetEmail", email);
        session.setAttribute("passwordResetNotice", GENERIC_NOTICE);

        PasswordResetDAO dao = new PasswordResetDAOImpl();
        String otpHash = null;
        boolean otpSaved = false;
        boolean emailSent = false;
        try {
            Integer userId = dao.findUserIdByEmail(email);
            if (userId != null) {
                String otp = PasswordResetOtpUtil.generateOtp();
                otpHash = PasswordResetOtpUtil.hashOtp(email, otp);
                Timestamp expiry = Timestamp.from(Instant.now().plusSeconds(OTP_EXPIRY_MINUTES * 60L));
                otpSaved = dao.saveOtp(userId, otpHash, expiry);
                if (otpSaved) {
                    PasswordResetMailer.sendOtpEmail(email, otp, OTP_EXPIRY_MINUTES);
                    emailSent = true;
                }
            }
        } catch (Exception exception) {
            // Never include the submitted email, OTP, OTP hash, or SMTP credentials in logs.
            getServletContext().log("Password reset OTP request could not be completed.", exception);
        } finally {
            if (otpSaved && !emailSent && otpHash != null) {
                try {
                    dao.deleteOtp(otpHash);
                } catch (SQLException cleanupException) {
                    getServletContext().log("Could not invalidate an OTP after an email delivery failure.", cleanupException);
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/reset-password");
    }
}
