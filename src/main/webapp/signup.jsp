<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/signup.css">
</head>
<body class="signup-page">

    <div class="gradient"></div>

    <div class="container signup-container">
        <div class="login signup-card">
            <h1>Create Account</h1>
            <p>Join us and enjoy delicious food delivered to your doorstep on time.</p>

            <form action="<%=request.getContextPath()%>/Signup" method="post">

                <div class="input">
                    <input
                        type="text"
                        name="name"
                        placeholder="Full Name"
                        minlength="3"
                        maxlength="50"
                        pattern="[A-Za-z ]+"
                        title="Name should contain only letters and spaces."
                        required>
                </div>

                <div class="input">
                    <input
                        type="email"
                        name="email"
                        id="email"
                        placeholder="Email Address"
                        title="Enter a valid email like abc@gmail.com"
                        pattern="[a-z0-9._]+@[a-z]+\.[a-z]{2,}"
                        required>
                </div>

                <div class="input password-box">
                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Password"
                        minlength="8"
                        pattern="^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[@$!%*?&])[A-Za-z0-9@$!%*?&]{8,}$"
                        title="Password must contain at least 8 characters, one uppercase letter, one lowercase letter, one number and one special character."
                        required>
                </div>

                <div class="input">
                    <textarea
                        name="address"
                        placeholder="Address"
                        minlength="3"
                        maxlength="50"
                        required></textarea>
                </div>

                <div class="input">
                    <input
                        type="tel"
                        name="phone"
                        placeholder="Phone Number"
                        pattern="[6-9][0-9]{9}"
                        maxlength="10"
                        minlength="10"
                        title="Enter a valid 10-digit mobile number."
                        required>
                </div>

                <button type="submit">🧡 Create Account</button>

                <div class="bottom">
                    Already have an account?
                    <a href="<%=request.getContextPath()%>/signin.jsp">Login</a>
                </div>

            </form>
        </div>
    </div>

</body>
</html>