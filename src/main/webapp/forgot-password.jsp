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
    <title>BiteBloom | Forgot Password</title>
    <link rel="icon"
          type="image/png"
          href="<%= request.getContextPath() %>/images/bitebloom-favicon.png">
    <link rel="stylesheet" href="<%= contextPath %>/css/common.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/signin.css">
</head>
<body class="login-page">
    <div class="gradient" aria-hidden="true"></div>
    <main class="auth-container">
        <section class="auth-card auth-card-compact" aria-labelledby="forgot-title">
            <p class="brand-mark">BITE<span>BLOOM</span></p>
            <h1 id="forgot-title">Forgot Password?</h1>
            <p class="subtitle">Enter the email address associated with your BiteBloom account. We'll send a one-time code if an account exists.</p>

            <% if (request.getAttribute("formError") != null) { %>
                <p class="message error-message"><%= escapeHtml(request.getAttribute("formError")) %></p>
            <% } %>

            <form action="<%= contextPath %>/forgot-password" method="post" class="auth-form">
                <label for="email">Email address</label>
                <div class="input-wrap">
                    <input type="email" id="email" name="email" autocomplete="email"
                           placeholder="you@example.com" maxlength="254" required>
                </div>
                <button type="submit" class="primary-button">Send OTP</button>
            </form>

            <p class="register-prompt"><a class="text-link" href="<%= contextPath %>/signin">Back to Sign In</a></p>
        </section>
    </main>
</body>
</html>
