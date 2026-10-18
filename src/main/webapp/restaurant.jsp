<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Restaurant" %>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurants</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/restaurant.css">
</head>
<body>
<%
    List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
%>

<section class="hero">
    <video autoplay muted loop playsinline id="bg-video">
        <source src="<%=request.getContextPath()%>/videos/backgroundvid.mp4" type="video/mp4">
    </video>

<div class="overlay"></div>

<div class="hero-content">
    <h1>India’s #1 <br> food delivery app</h1>
    <p>Experience the food delivered to your doorstep on time.</p>
    <a href="#restaurants" class="scroll-btn">Explore Restaurants</a>
</div>

</section>

<section class="restaurants-section" id="restaurants">
    <div class="section-title">Restaurants</div>

<%
    if (restaurants != null && !restaurants.isEmpty()) {
%>
    <div class="restaurants-grid">
        <%
            for (Restaurant restaurant : restaurants) {
        %>
            <a class="restaurant-link"
  			 	href="<%=request.getContextPath()%>/menu?restaurantId=<%=restaurant.getRestaurant_id()%>">
                <div class="restaurant-card">
                    <img class="restaurant-img"
                         src="<%=request.getContextPath()%>/<%=restaurant.getImagepath()%>"
                         alt="<%=restaurant.getName()%>">

                    <div class="restaurant-body">
                        <div class="restaurant-name"><%=restaurant.getName()%></div>

                        <div class="restaurant-inline">
                            <span class="rating"><%=restaurant.getRating()%> ★</span>
                            <span class="delivery-time"><%=restaurant.getDelivery_time()%> min</span>
                        </div>

                        <div class="restaurant-meta">
                            <div><%=restaurant.getCuisine_type()%></div>
                            <div><%=restaurant.getAddress()%></div>
                        </div>
                    </div>
                </div>
            </a>
        <%
            }
        %>
    </div>
<%
    } else {
%>
    <div class="empty-state">No restaurants found.</div>
<%
    }
%>

</section>
</body>
</html>
