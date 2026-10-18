<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="com.tap.model.User" %>
<%@ page import="java.util.Collection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout</title>
    <style>
        *{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Poppins, sans-serif;
        }

        body{
            background: #f8fafc;
            color: #111827;
        }

        .page{
            width: 100%;
        }

        .top-bar{
            position: sticky;
            top: 0;
            z-index: 100;
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid #e5e7eb;
        }

        .top-bar-inner{
            width: min(1150px, 92%);
            margin: 0 auto;
            padding: 16px 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
        }

        .brand{
            display: flex;
            flex-direction: column;
            gap: 3px;
        }

        .brand-name{
            font-size: 1.15rem;
            font-weight: 800;
            color: #111827;
        }

        .brand-sub{
            font-size: 0.92rem;
            color: #6b7280;
        }

        .back-link{
            text-decoration: none;
            background: #111827;
            color: #fff;
            padding: 10px 16px;
            border-radius: 999px;
            font-weight: 600;
            font-size: 0.95rem;
        }

        .container{
            width: min(1150px, 92%);
            margin: 0 auto;
            padding: 24px 0 40px;
        }

        .title{
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 6px;
        }

        .subtitle{
            color: #6b7280;
            margin-bottom: 22px;
        }

        .notice{
            background: #fff7ed;
            border: 1px solid #fdba74;
            color: #9a3412;
            padding: 14px 16px;
            border-radius: 14px;
            margin-bottom: 18px;
            display: flex;
            justify-content: space-between;
            gap: 12px;
            align-items: center;
            flex-wrap: wrap;
        }

        .notice a{
            text-decoration: none;
            background: #111827;
            color: #fff;
            padding: 9px 14px;
            border-radius: 999px;
            font-weight: 600;
            font-size: 0.95rem;
        }

        .layout{
            display: grid;
            grid-template-columns: 1.2fr 0.8fr;
            gap: 20px;
        }

        .card{
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 20px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        .card-header{
            padding: 18px 20px;
            border-bottom: 1px solid #e5e7eb;
            font-size: 1.15rem;
            font-weight: 800;
        }

        .card-body{
            padding: 20px;
        }

        .section-title{
            font-size: 1rem;
            font-weight: 700;
            margin-bottom: 14px;
            color: #111827;
        }

        .grid-2{
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }

        .field-group{
            margin-bottom: 14px;
        }

        .label{
            display: block;
            font-size: 0.95rem;
            font-weight: 700;
            margin-bottom: 8px;
            color: #374151;
        }

        .field{
            width: 100%;
            padding: 13px 14px;
            border: 1px solid #d1d5db;
            border-radius: 14px;
            outline: none;
            font-size: 0.98rem;
            background: #fff;
        }

        .field:focus{
            border-color: #f97316;
            box-shadow: 0 0 0 3px rgba(249,115,22,0.12);
        }

        textarea.field{
            min-height: 110px;
            resize: vertical;
        }

        .readonly-field{
            background: #f9fafb;
            color: #374151;
            cursor: not-allowed;
        }

        .hint{
            margin-top: 6px;
            font-size: 0.88rem;
            color: #6b7280;
        }

        .payment-box{
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            padding: 14px;
            background: #f8fafc;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-top: 8px;
        }

        .payment-left{
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .payment-title{
            font-weight: 700;
            color: #111827;
        }

        .payment-sub{
            font-size: 0.92rem;
            color: #6b7280;
        }

        .cod-badge{
            background: #dcfce7;
            color: #166534;
            padding: 8px 12px;
            border-radius: 999px;
            font-weight: 700;
            font-size: 0.92rem;
            white-space: nowrap;
        }

        .summary-item{
            display: flex;
            justify-content: space-between;
            gap: 10px;
            padding: 10px 0;
            border-bottom: 1px dashed #e5e7eb;
            font-size: 0.96rem;
        }

        .summary-item:last-child{
            border-bottom: none;
        }

        .summary-total{
            margin-top: 12px;
            padding-top: 14px;
            border-top: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            font-size: 1.12rem;
            font-weight: 800;
        }

        .confirm-btn{
            width: 100%;
            border: none;
            background: linear-gradient(90deg, #f97316, #fb923c);
            color: #fff;
            padding: 14px 18px;
            border-radius: 999px;
            font-size: 1rem;
            font-weight: 800;
            cursor: pointer;
            margin-top: 18px;
        }

        .small-note{
            margin-top: 10px;
            font-size: 0.88rem;
            color: #6b7280;
            line-height: 1.5;
        }

        .login-box{
            background: #fff7ed;
            border: 1px solid #fdba74;
            color: #9a3412;
            padding: 14px 16px;
            border-radius: 14px;
            margin-bottom: 18px;
        }

        .login-box a{
            display: inline-block;
            margin-top: 10px;
            text-decoration: none;
            background: #111827;
            color: #fff;
            padding: 9px 14px;
            border-radius: 999px;
            font-weight: 600;
        }

        .error-box{
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #b91c1c;
            padding: 14px 16px;
            border-radius: 14px;
            margin-bottom: 18px;
        }

        @media (max-width: 900px){
            .layout{
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 640px){
            .top-bar-inner{
                flex-direction: column;
                align-items: flex-start;
            }

            .grid-2{
                grid-template-columns: 1fr;
            }

            .title{
                font-size: 1.7rem;
            }
        }
    </style>
</head>
<body>

<%
    Cart cart = (Cart) request.getAttribute("cart");
    if (cart == null) {
        cart = (Cart) session.getAttribute("cart");
    }

    User loggedInUser = (User) request.getAttribute("loggedInUser");
    Boolean loginRequired = (Boolean) request.getAttribute("loginRequired");

    String checkoutMessage = (String) session.getAttribute("checkoutMessage");
    if (checkoutMessage != null) {
        session.removeAttribute("checkoutMessage");
    }

    String errorMessage = (String) request.getAttribute("errorMessage");

    String fullName = "";
    String phone = "";
    String email = "";
    String address = "";

    if (loggedInUser != null) {
        fullName = loggedInUser.getName() != null ? loggedInUser.getName() : "";
        phone = loggedInUser.getPhone() != null ? loggedInUser.getPhone() : "";
        email = loggedInUser.getEmail() != null ? loggedInUser.getEmail() : "";
        address = loggedInUser.getAddress() != null ? loggedInUser.getAddress() : "";
    }

    String continueUrl = request.getContextPath() + "/cart";
%>

<div class="page">
    <div class="top-bar">
        <div class="top-bar-inner">
            <div class="brand">
                <div class="brand-name">Checkout</div>
                <div class="brand-sub">Fast delivery, simple payment</div>
            </div>
            <a class="back-link" href="<%=continueUrl%>">← Back to Cart</a>
        </div>
    </div>

    <div class="container">
        <div class="title">Confirm your order</div>
        <div class="subtitle">Add delivery details and place your order with Cash on Delivery.</div>

        <%
            if (checkoutMessage != null) {
        %>
            <div class="notice">
                <span><%= checkoutMessage %></span>
                <a href="<%=request.getContextPath()%>/login.jsp">Login Now</a>
            </div>
        <%
            }
        %>

        <%
            if (loginRequired != null && loginRequired) {
        %>
            <div class="notice">
                <span>Please login before confirming the order.</span>
                <a href="<%=request.getContextPath()%>/login.jsp">Login Now</a>
            </div>
        <%
        }
        %>

        <%
            if (errorMessage != null) {
        %>
            <div class="error-box"><%= errorMessage %></div>
        <%
            }
        %>

        <div class="layout">
            <div class="card">
                <div class="card-header">Delivery details</div>
                <div class="card-body">
                    <form action="<%=request.getContextPath()%>/checkout" method="post">
                        <div class="grid-2">
                            <div class="field-group">
                                <label class="label">Full Name</label>
                                <input class="field readonly-field" type="text" value="<%=fullName%>" readonly>
                            </div>
                            <div class="field-group">
                                <label class="label">Mobile Number</label>
                                <input class="field readonly-field" type="text" value="<%=phone%>" readonly>
                            </div>
                        </div>

                        <div class="field-group">
                            <label class="label">Email Address</label>
                            <input class="field readonly-field" type="text" value="<%=email%>" readonly>
                        </div>

                        <div class="grid-2">
                            <div class="field-group">
                                <label class="label">House / Flat / Building No.</label>
                                <input class="field" type="text" name="houseName" placeholder="Ex: Flat 402">
                            </div>
                            <div class="field-group">
                                <label class="label">Street / Area</label>
                                <input class="field" type="text" name="street" placeholder="Ex: BTM 2nd Stage">
                            </div>
                        </div>

                        <div class="grid-2">
                            <div class="field-group">
                                <label class="label">Landmark</label>
                                <input class="field" type="text" name="landmark" placeholder="Ex: Near Metro Station">
                            </div>
                            <div class="field-group">
                                <label class="label">City</label>
                                <input class="field" type="text" name="city" placeholder="Ex: Bangalore">
                            </div>
                        </div>

                        <div class="grid-2">
                            <div class="field-group">
                                <label class="label">Pincode</label>
                                <input class="field" type="text" name="pincode" maxlength="6" placeholder="Ex: 560076">
                            </div>
                            <div class="field-group">
                                <label class="label">Address Type</label>
                                <select class="field" name="addressType">
                                    <option value="Home">Home</option>
                                    <option value="Work">Work</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                        </div>

                        <div class="field-group">
                            <label class="label">Complete Delivery Address</label>
                            <textarea class="field" name="deliveryAddress" placeholder="You can keep this editable or let the controller build it from the fields above"><%=address%></textarea>
                        </div>

                        <div class="field-group">
                            <label class="label">Payment Method</label>
                            <div class="payment-box">
                                <div class="payment-left">
                                    <div class="payment-title">Cash on Delivery</div>
                                    <div class="payment-sub">Only payment mode available right now</div>
                                </div>
                                <div class="cod-badge">COD</div>
                            </div>
                        </div>

                        <button type="submit" class="confirm-btn">Confirm Order</button>
                        <div class="small-note">
                            By confirming, your order will be placed and sent for preparation.
                        </div>
                    </form>
                </div>
            </div>

            <div class="card">
                <div class="card-header">Order summary</div>
                <div class="card-body">
                    <%
                        if (cart != null && !cart.isEmpty()) {
                            Collection<CartItem> items = cart.getCartItems();
                            for (CartItem item : items) {
                    %>
                        <div class="summary-item">
                            <span><%= item.getMenu().getItemName() %> × <%= item.getQuantity() %></span>
                            <span>₹<%= item.getSubTotal() %></span>
                        </div>
                    <%
                            }
                    %>
                        <div class="summary-total">
                            <span>Total</span>
                            <span>₹<%= cart.getGrandTotal() %></span>
                        </div>
                    <%
                        } else {
                    %>
                        <div class="summary-item">
                            <span>Your cart is empty</span>
                            <span>₹0</span>
                        </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>