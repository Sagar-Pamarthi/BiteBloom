<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>BiteBloom | Create Account</title>
    
    <link rel="icon"
          type="image/png"
          href="<%= request.getContextPath() %>/images/bitebloom-favicon.png">

    <!-- Shared styles -->
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/common.css">

    <!-- Signup-specific styles -->
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/signup.css">

    <!-- Browser tab icon -->
    <link rel="icon"
          type="image/png"
          href="<%= request.getContextPath() %>/images/favicon.png">
</head>

<body class="signup-page">

    <div class="gradient"></div>

    <main class="container signup-container">

        <section class="login signup-card">

            <h1>Create Account</h1>

            <p class="signup-description">
                Join BiteBloom and enjoy delicious food delivered
                to your doorstep.
            </p>

            <form action="<%= request.getContextPath() %>/Signup"
                  method="post">

                <!-- Full name -->
                <div class="input">
                    <input
                        type="text"
                        name="name"
                        placeholder="Full Name"
                        minlength="3"
                        maxlength="50"
                        pattern="[A-Za-z ]+"
                        title="Name should contain only letters and spaces."
                        autocomplete="name"
                        required>
                </div>

                <!-- Email -->
                <div class="input">
                    <input
                        type="email"
                        name="email"
                        id="email"
                        placeholder="Email Address"
                        maxlength="254"
                        autocomplete="email"
                        required>
                </div>

                <!-- Password -->
                <div class="input password-box">
                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Password"
                        minlength="8"
                        maxlength="72"
                        pattern="(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[@$!%*?&])[A-Za-z0-9@$!%*?&]{8,}"
                        title="Use at least 8 characters, including an uppercase letter, a lowercase letter, a number, and a special character (@$!%*?&)."
                        autocomplete="new-password"
                        required>
                </div>

                <!-- Address -->
                <div class="input">
                    <textarea
                        name="address"
                        placeholder="Address"
                        minlength="3"
                        maxlength="255"
                        autocomplete="street-address"
                        required></textarea>
                </div>

                <!-- Phone -->
                <div class="input">
                    <input
                        type="tel"
                        name="phone"
                        placeholder="10-digit Mobile Number"
                        pattern="[6-9][0-9]{9}"
                        maxlength="10"
                        minlength="10"
                        title="Enter a valid 10-digit Indian mobile number."
                        autocomplete="tel-national"
                        required>
                </div>

                <button type="submit">
                    🧡 Create Account
                </button>

                <div class="bottom">
                    Already have an account?
                    <a href="<%= request.getContextPath() %>/signin">
                        Sign In
                    </a>
                </div>

            </form>

        </section>

    </main>

</body>
</html>