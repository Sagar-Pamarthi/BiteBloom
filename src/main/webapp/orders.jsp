<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.tap.model.Orders" %>
<%@ page import="com.tap.model.Order_item" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.User" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BiteBloom | My Orders</title>
    <link rel="icon"
          type="image/png"
          href="<%= request.getContextPath() %>/images/bitebloom-favicon.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/common.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/orders.css">
</head>
<body class="orders-page-body">
<%
    String contextPath = request.getContextPath();
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    Cart cart = (Cart) session.getAttribute("cart");
    int cartCount = cart == null ? 0 : cart.getTotalItems();

    String firstName = "";
    if (loggedInUser != null && loggedInUser.getName() != null && !loggedInUser.getName().trim().isEmpty()) {
        firstName = loggedInUser.getName().trim().split("\\s+")[0];
    }

    List<Orders> orders = (List<Orders>) request.getAttribute("orders");
    Map<Integer, List<Order_item>> orderItemsMap = (Map<Integer, List<Order_item>>) request.getAttribute("orderItemsMap");
    Map<Integer, Restaurant> restaurantMap = (Map<Integer, Restaurant>) request.getAttribute("restaurantMap");
    Map<Integer, Menu> menuMap = (Map<Integer, Menu>) request.getAttribute("menuMap");
    int orderCount = orders == null ? 0 : orders.size();
%>

<!-- Same shared navbar markup as cart.jsp; common.css owns its styling. -->
<header class="navbar">
    <a class="brand" href="<%= contextPath %>/restaurants" aria-label="BiteBloom home">
        <span class="brand-icon" aria-hidden="true">🍊</span>
        <span class="brand-name">Bite<span>Bloom</span></span>
    </a>

    <nav class="nav-links" aria-label="Main navigation">
        <a href="<%= contextPath %>/restaurants">
            <span class="nav-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24"><path d="m3 10 9-7 9 7"></path><path d="M5 9v11h14V9"></path><path d="M9 20v-6h6v6"></path></svg>
            </span>
            <span>Home</span>
        </a>

        <details class="nav-search">
            <summary class="search-toggle">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"></circle><path d="m20 20-4-4"></path></svg>
                </span>
                <span>Search</span>
            </summary>
            <form class="navbar-search-form" action="<%= contextPath %>/restaurants" method="get" role="search">
                <span class="restaurant-search-icon" aria-hidden="true">⌕</span>
                <label class="visually-hidden" for="orders-page-search">Search restaurants or food</label>
                <input id="orders-page-search" type="search" name="search" placeholder="Search for food or restaurants...">
                <button type="submit" aria-label="Submit search">→</button>
            </form>
        </details>

        <a href="<%= contextPath %>/cart" aria-label="Shopping cart">
            <span class="nav-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.7 13.4a2 2 0 0 0 2 1.6h9.7a2 2 0 0 0 2-1.6L23 6H6"></path></svg>
            </span>
            <span>Cart</span>
            <span class="cart-count"><%= cartCount %></span>
        </a>

        <% if (loggedInUser != null) { %>
            <a class="signin-link" href="<%= contextPath %>/profile" aria-label="Your profile">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"></circle><path d="M5 21v-2a7 7 0 0 1 14 0v2"></path></svg>
                </span>
                <span><%= firstName %></span>
            </a>
        <% } else { %>
            <a class="signin-link" href="<%= contextPath %>/signin">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"></circle><path d="M5 21v-2a7 7 0 0 1 14 0v2"></path></svg>
                </span>
                <span>Sign In</span>
            </a>
        <% } %>
    </nav>
</header>

<main class="orders-page">
    <!-- Same 300px image-banner structure, overlay treatment and text alignment as cart.jsp. -->
    <section class="orders-hero" aria-labelledby="orders-hero-title">
        <img
            class="orders-hero-image"
            src="https://images.unsplash.com/photo-1700513971603-eda40374ba0a?auto=format&fit=crop&fm=jpg&ixid=NHwxMjA3fDA%3D&ixlib=rb-4.1.0&q=80&w=1800"
            alt=""
            aria-hidden="true">
        <div class="orders-hero-overlay" aria-hidden="true"></div>
        <div class="orders-hero-copy">
            <p class="orders-eyebrow">YOUR BITEBLOOM JOURNEY</p>
            <h1 id="orders-hero-title">My Orders</h1>
            <p class="orders-hero-subtitle">Your favourite moments, all in one place.</p>
        </div>
    </section>

    <section class="orders-content-area" aria-labelledby="orders-section-title">
        <div class="orders-layout">
            <section class="orders-list" aria-labelledby="orders-section-title">
                <div class="orders-section-heading">
                    <div>
                        <p class="orders-section-eyebrow">MADE, DELIVERED, ENJOYED</p>
                        <h2 id="orders-section-title">Your order history</h2>
                        <p class="orders-section-subtitle">Every order, every item, every detail.</p>
                    </div>
                    <span class="orders-count"><%= orderCount %> <%= orderCount == 1 ? "order" : "orders" %></span>
                </div>

                <% if (orders == null || orders.isEmpty()) { %>
                    <div class="orders-empty-state">
                        <div class="orders-empty-icon" aria-hidden="true">🍽</div>
                        <p class="orders-empty-eyebrow">A LITTLE ROOM FOR SOMETHING DELICIOUS</p>
                        <h3>Your order story starts here</h3>
                        <p>You haven't placed an order yet. Explore BiteBloom and find something delicious.</p>
                        <a class="orders-cta-button" href="<%= contextPath %>/restaurants">Explore Restaurants <span aria-hidden="true">→</span></a>
                    </div>
                <% } else { %>
                    <% for (Orders order : orders) {
                        Restaurant restaurant = restaurantMap == null ? null : restaurantMap.get(order.getRestaurant_id());
                        List<Order_item> items = orderItemsMap == null ? null : orderItemsMap.get(order.getOrder_id());
                        if (items == null) {
                            items = Collections.emptyList();
                        }

                        String status = order.getStatus() == null || order.getStatus().trim().isEmpty() ? "Placed" : order.getStatus().trim();
                        String normalizedStatus = status.toLowerCase(Locale.ROOT);
                        String statusClass = "placed";
                        if (normalizedStatus.equals("delivered")) {
                            statusClass = "delivered";
                        } else if (normalizedStatus.equals("preparing")) {
                            statusClass = "preparing";
                        } else if (normalizedStatus.equals("on the way") || normalizedStatus.equals("on_the_way")) {
                            statusClass = "ontheway";
                        } else if (normalizedStatus.equals("cancelled")) {
                            statusClass = "cancelled";
                        }

                        String restaurantImage = restaurant == null ? null : restaurant.getImagepath();
                        if (restaurantImage == null || restaurantImage.trim().isEmpty()) {
                            restaurantImage = "images/default-restaurant.jpg";
                        }
                        while (restaurantImage.startsWith("/")) {
                            restaurantImage = restaurantImage.substring(1);
                        }
                    %>
                        <article class="order-card" aria-label="Order <%= order.getOrder_id() %>">
                            <header class="order-card-header">
                                <div class="order-reference">
                                    <span class="order-field-label">ORDER ID</span>
                                    <strong>#<%= order.getOrder_id() %></strong>
                                </div>
                                <div class="order-date-wrap">
                                    <span class="order-field-label">PLACED ON</span>
                                    <time><%= order.getOrder_date() %></time>
                                </div>
                                <span class="order-status <%= statusClass %>"><span class="order-status-dot" aria-hidden="true"></span><%= status %></span>
                            </header>

                            <div class="order-restaurant-block">
                                <img class="order-restaurant-image"
                                     src="<%= contextPath %>/<%= restaurantImage %>"
                                     alt="<%= restaurant == null ? "Restaurant" : restaurant.getName() %>"
                                     loading="lazy">
                                <div class="order-restaurant-info">
                                    <p class="order-small-label">FROM YOUR FAVOURITE PLACE</p>
                                    <h3><%= restaurant == null ? "Restaurant details unavailable" : restaurant.getName() %></h3>
                                    <p class="order-restaurant-address"><span aria-hidden="true">⌖</span>
                                        <%= restaurant == null || restaurant.getAddress() == null || restaurant.getAddress().trim().isEmpty() ? "Address unavailable" : restaurant.getAddress() %>
                                    </p>
                                    <% if (restaurant != null) { %>
                                        <p class="order-delivery-time"><span aria-hidden="true">◷</span> Delivery estimate: <strong><%= restaurant.getDelivery_time() %> mins</strong></p>
                                    <% } %>
                                </div>
                            </div>

                            <div class="order-items-section">
                                <div class="order-items-heading">
                                    <h4>Items in this order</h4>
                                    <span><%= items.size() %> <%= items.size() == 1 ? "item" : "items" %></span>
                                </div>
                                <% if (items.isEmpty()) { %>
                                    <p class="order-no-items">Item details are currently unavailable.</p>
                                <% } else { %>
                                    <% for (Order_item item : items) {
                                        Menu menu = menuMap == null ? null : menuMap.get(item.getMenu_id());
                                    %>
                                        <div class="order-item-row">
                                            <div class="order-item-description">
                                                <span class="order-item-marker" aria-hidden="true">✦</span>
                                                <span class="order-item-name"><%= menu == null ? "Menu item" : menu.getItemName() %></span>
                                                <span class="order-item-quantity">× <%= item.getQuantity() %></span>
                                            </div>
                                            <strong class="order-item-price">₹<%= item.getItem_total() %></strong>
                                        </div>
                                    <% } %>
                                <% } %>
                            </div>

                            <div class="order-card-bottom">
                                <div class="order-payment-info">
                                    <span class="order-field-label">PAYMENT METHOD</span>
                                    <strong><span aria-hidden="true">▣</span> <%= order.getPayment_mode() == null || order.getPayment_mode().trim().isEmpty() ? "Not specified" : order.getPayment_mode() %></strong>
                                </div>
                                <div class="order-total-info">
                                    <span class="order-field-label">ORDER TOTAL</span>
                                    <strong>₹<%= order.getTotal_amount() %></strong>
                                </div>
                            </div>
                        </article>
                    <% } %>
                <% } %>
            </section>

            <aside class="orders-promo-card" aria-labelledby="orders-promo-title">
                <div class="orders-promo-art" aria-hidden="true">
                    <span class="promo-spark promo-spark-one">✦</span>
                    <span class="promo-spark promo-spark-two">✧</span>
                    <span class="promo-food-icon">🍱</span>
                </div>
                <p class="orders-promo-eyebrow">A LITTLE MORE DELICIOUS</p>
                <h2 id="orders-promo-title">Craving something again?</h2>
                <p class="orders-promo-copy">Find your next comfort-food favourite and make another happy food memory.</p>
                <a class="orders-cta-button orders-promo-button" href="<%= contextPath %>/restaurants">Explore Restaurants <span aria-hidden="true">→</span></a>
                <div class="orders-promo-footnote"><span aria-hidden="true">♥</span> Good food. Happy moments.</div>
            </aside>
        </div>
    </section>
</main>

<!-- Same shared footer markup as cart.jsp; common.css owns its styling. -->
<footer class="footer">
    <a class="footer-brand" href="<%= contextPath %>/restaurants">🍊 Bite<span>Bloom</span></a>
    <p>Fresh food, happy mood. Made for food lovers.</p>
    <div class="footer-links">
        <a href="<%= contextPath %>/restaurants">Restaurants</a>
        <a href="<%= contextPath %>/cart">Cart</a>
        <a href="<%= contextPath %>/orders">Orders</a>
    </div>
    <div class="footer-bottom">
        &copy; 2026 BiteBloom. All rights reserved.
    </div>
</footer>

</body>
</html>
