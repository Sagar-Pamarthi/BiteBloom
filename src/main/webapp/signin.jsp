<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Signin</title>

<link rel="stylesheet"
      href="<%=request.getContextPath()%>/css/style.css">

<link rel="stylesheet"
      href="<%=request.getContextPath()%>/css/signin.css">

</head>

<body class="login-page">

<div class="gradient"></div>

<div class="container">

    <div class="login">

        <h1>Welcome Back!</h1>

        <p>Turn Your Hunger into Happiness with Us.</p>

        <%
            String loginError = (String)request.getAttribute("loginError");
            if(loginError != null){
        %>

            <p style="color:#ffb3b3;">
                <%=loginError%>
            </p>

        <%
            }
        %>

        <form action="<%=request.getContextPath()%>/signin" method="post">

            <div class="input">
                <input
                    type="email"
                    name="email"
                    placeholder="Email"
                    required>
            </div>

            <div class="input password-box">

                <input
                    type="password"
                    name="password"
                    placeholder="Password"
                    required>

            </div>

            <button type="submit">
                Login
            </button>

        </form>

        <div class="bottom">

            Don't have an account?

            <a href="signup.jsp">
                Register Here
            </a>

        </div>

    </div>

</div>

</body>
</html>