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
    <title>BiteBloom | Sign In</title>
    <link rel="icon"
          type="image/png"
          href="<%= request.getContextPath() %>/images/bitebloom-favicon.png">
    <link rel="stylesheet" href="<%= contextPath %>/css/common.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/signin.css">
</head>
<body class="login-page">
    <div class="gradient" aria-hidden="true"></div>
    <main class="auth-container">
        <section class="auth-card login-card" aria-labelledby="signin-title">
            <p class="brand-mark">BITE<span>BLOOM</span></p>
            <h1 id="signin-title">Welcome Back!</h1>
            <p class="subtitle">Turn Your Hunger into Happiness with Us.</p>

            <% if (request.getAttribute("resetSuccess") != null) { %>
                <p class="message success-message"><%= escapeHtml(request.getAttribute("resetSuccess")) %></p>
            <% } %>
            <% if (request.getAttribute("loginError") != null) { %>
                <p class="message error-message"><%= escapeHtml(request.getAttribute("loginError")) %></p>
            <% } %>

            <form action="<%= contextPath %>/signin" method="post" class="auth-form">
                <label for="email">Email address</label>
                <div class="input-wrap">
                    <input type="email" id="email" name="email" autocomplete="email"
                           placeholder="you@example.com" required>
                </div>
                <label for="password">Password</label>
                <div class="input-wrap">
                    <input type="password" id="password" name="password" autocomplete="current-password"
                           placeholder="Enter your password" required>
                </div>
                <div class="form-options">
                    <a class="text-link" href="<%= contextPath %>/forgot-password">Forgot password?</a>
                </div>
                <button type="submit" class="primary-button">Sign In</button>
            </form>

            <p class="register-prompt">Don't have an account?
                <a class="text-link" href="<%= contextPath %>/signup.jsp">Register Here</a>
            </p>
        </section>
    </main>
</body>
</html>
