<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
    private String escapeHtml(Object value) {
        if (value == null) return "";
        return value.toString().replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BiteBloom | Reset Password</title>
    <link rel="icon"
          type="image/png"
          href="<%= request.getContextPath() %>/images/bitebloom-favicon.png">
    <link rel="stylesheet" href="<%= contextPath %>/css/common.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/signin.css">
</head>
<body class="login-page">
    <div class="gradient" aria-hidden="true"></div>
    <main class="auth-container">
        <section class="auth-card auth-card-compact" aria-labelledby="reset-title">
            <p class="brand-mark">BITE<span>BLOOM</span></p>
            <h1 id="reset-title">Reset Your Password</h1>
            <p class="subtitle">Enter the six-digit code sent to your email, then choose a new password. The code expires after five minutes.</p>

            <% if (request.getAttribute("resetNotice") != null) { %>
                <p class="message success-message"><%= escapeHtml(request.getAttribute("resetNotice")) %></p>
            <% } %>
            <% if (request.getAttribute("resetError") != null) { %>
                <p class="message error-message"><%= escapeHtml(request.getAttribute("resetError")) %></p>
            <% } %>

            <form action="<%= contextPath %>/reset-password" method="post" class="auth-form">
                <label for="otp">Email verification code</label>
                <div class="input-wrap">
                    <input type="text" id="otp" name="otp" inputmode="numeric" autocomplete="one-time-code"
                           pattern="[0-9]{6}" minlength="6" maxlength="6" placeholder="6-digit code" required>
                </div>
                <label for="password">New password</label>
                <div class="input-wrap">
                    <input type="password" id="password" name="password" autocomplete="new-password"
                           minlength="8" placeholder="At least 8 characters" required>
                </div>
                <label for="confirmPassword">Confirm new password</label>
                <div class="input-wrap">
                    <input type="password" id="confirmPassword" name="confirmPassword" autocomplete="new-password"
                           minlength="8" placeholder="Re-enter new password" required>
                </div>
                <button type="submit" class="primary-button">Verify Code &amp; Reset Password</button>
            </form>

            <p class="register-prompt">Didn't receive a code? <a class="text-link" href="<%= contextPath %>/forgot-password">Request another OTP</a></p>
            <p class="register-prompt"><a class="text-link" href="<%= contextPath %>/signin">Back to Sign In</a></p>
        </section>
    </main>
</body>
</html>
