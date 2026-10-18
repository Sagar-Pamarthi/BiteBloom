<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu</title>
	<link rel="stylesheet" href="<%=request.getContextPath()%>/css/menu.css">
	
</head>
<body>
<%
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    List<Menu> menus = (List<Menu>) request.getAttribute("menus");
    Cart cart = (Cart) session.getAttribute("cart");
%>

<div class="navbar">
    <div class="navbar-inner">
        <a class="nav-brand" href="<%=request.getContextPath()%>/restaurant">Food Hub</a>
        <div class="nav-links">
            <a href="<%=request.getContextPath()%>/restaurant">Restaurant</a>
            <a href="<%=request.getContextPath()%>/cart">Cart</a>
            <a href="<%=request.getContextPath()%>/login.jsp">Sign in</a>
        </div>
    </div>
</div>

<div class="container">
    <section class="restaurant-section">
        <%
            if (restaurant != null) {
        %>
            <h1 class="restaurant-title"><%=restaurant.getName()%></h1>

            <div class="restaurant-hero">
                <img class="hero-image"
                     src="<%=request.getContextPath()%>/<%=restaurant.getImagepath()%>"
                     alt="<%=restaurant.getName()%>">

                <div class="hero-info">
                    <div class="hero-row">
                        <span class="rating-pill">★ <%=restaurant.getRating()%></span>
                        <span class="meta-pill"><%=restaurant.getCuisine_type()%></span>
                        <span class="meta-pill"><%=restaurant.getAddress()%></span>
                        <%
                            if (restaurant.isIs_active()) {
                        %>
                            <span class="meta-pill open-pill">Open now</span>
                        <%
                            } else {
                        %>
                            <span class="meta-pill closed-pill">Closed</span>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
        <%
            }
        %>
    </section>

    <div class="section-title">Recommended Items</div>

    <%
        if (menus != null && !menus.isEmpty()) {
    %>
        <div class="menu-list">
            <%
                for (Menu menu : menus) {
                    int menuId = menu.getMenu_id();
                    int quantity = 0;

                    if (cart != null && cart.getItems() != null && cart.getItems().containsKey(menuId)) {
                        CartItem item = cart.getItems().get(menuId);
                        if (item != null) {
                            quantity = item.getQuantity();
                        }
                    }

                    String imgPath = request.getContextPath() + "/images/menu-default.jpg";
                    String dishType = menu.getDishType();  
                    boolean isVeg = dishType != null && dishType.equalsIgnoreCase("veg");
            %>
                <div class="menu-item">
                    <div class="item-left">
                        <div class="type-icon <%= isVeg ? "veg-icon" : "nonveg-icon" %>"></div>
                        <div class="item-name"><%=menu.getItemName()%></div>
                        <div class="item-price">₹<%=menu.getPrice()%></div>
                        <div class="item-desc"><%=menu.getDescription()%></div>
                    </div>

                    <div class="item-right">
                        <div class="item-image-wrap">
                            <img class="item-image" src="<%=imgPath%>" alt="Menu Item">
                        </div>

                        <div class="cart-control">
                            <%
                                if (quantity == 0) {
                            %>
                                <form action="<%=request.getContextPath()%>/cart" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="menuId" value="<%=menuId%>">
                                    <input type="hidden" name="restaurantId" value="<%=restaurant.getRestaurant_id()%>">
                                    <input type="hidden" name="source" value="menu">
                                    <button type="submit" class="add-btn">ADD</button>
                                </form>
                            <%
                                } else {
                            %>
                                <div class="qty-box">
                                    <form action="<%=request.getContextPath()%>/cart" method="post" class="qty-form">
                                        <input type="hidden" name="action" value="decrease">
                                        <input type="hidden" name="menuId" value="<%=menuId%>">
                                        <input type="hidden" name="restaurantId" value="<%=restaurant.getRestaurant_id()%>">
                                        <input type="hidden" name="source" value="menu">
                                        <button type="submit" class="qty-btn">−</button>
                                    </form>

                                    <span class="qty-value"><%=quantity%></span>

                                    <form action="<%=request.getContextPath()%>/cart" method="post" class="qty-form">
                                        <input type="hidden" name="action" value="increase">
                                        <input type="hidden" name="menuId" value="<%=menuId%>">
                                        <input type="hidden" name="restaurantId" value="<%=restaurant.getRestaurant_id()%>">
                                        <input type="hidden" name="source" value="menu">
                                        <button type="submit" class="qty-btn">+</button>
                                    </form>
                                </div>
                            <%
                                }
                            %>
                        </div>
                    </div>
                </div>
            <%
                }
            %>
        </div>
    <%
        } else {
    %>
        <div class="empty-state">No menu items found for this restaurant.</div>
    <%
        }
    %>
</div>
</body>
</html>