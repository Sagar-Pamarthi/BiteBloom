<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Restaurant" %>

<%
    List<Restaurant> restaurants =
        (List<Restaurant>) request.getAttribute("restaurants");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>BiteBloom | Restaurants</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/restaurants.css">
</head>

<body>

    
<!-- Navbar -->
<header class="navbar">

    <a class="brand" href="<%= request.getContextPath() %>/restaurants">
        <span class="brand-icon">🍊</span>
        <span class="brand-name">Lunch<span>Box</span></span>
    </a>

    <nav class="nav-links">
    
    	<a href="<%= request.getContextPath() %>/restaurants">
            <span class="nav-icon">⌂</span>
            <span>Home</span>
        </a>
    
        <a href="<%= request.getContextPath() %>/cart">
            <span class="nav-icon">🛒</span>
            <span>Cart</span>
            <span class="cart-count">0</span>
        </a>

        <a href="<%= request.getContextPath() %>/signin">
            <span class="nav-icon">👤</span>
            <span>Sign In</span>
        </a>
    </nav>

</header>
   
    <!-- Hero Section with Background Video -->
    <section class="hero" id="home">

        <video autoplay muted loop playsinline id="bg-video"
                src="<%= request.getContextPath() %>/videos/backgroundvid.mp4"
                type="video/mp4">
        </video>

        <div class="overlay"></div>

        <div class="hero-content">

            <h1>
                Good food,<br>
                delivered <span>fresh.</span>
            </h1>

            <p>
                Discover your favourite restaurants, enjoy delicious meals,
                and get fresh food delivered straight to your doorstep.
            </p>

            <div class="hero-actions">
                <a href="#restaurants" class="primary-btn">
                    Explore Restaurants <span>→</span>
                </a>

                <a href="#restaurants" class="secondary-btn">
                    Discover More
                </a>
            </div>

            <div class="hero-features">

                <div class="feature">
                    <span class="feature-icon">◷</span>
                    <div>
                        <strong>Fast Delivery</strong>
                        <small>At your doorstep</small>
                    </div>
                </div>

                <div class="feature-divider"></div>

                <div class="feature">
                    <span class="feature-icon">🌿</span>
                    <div>
                        <strong>Fresh Food</strong>
                        <small>Serve with care</small>
                    </div>
                </div>

                <div class="feature-divider"></div>

                <div class="feature">
                    <span class="feature-icon">♢</span>
                    <div>
                        <strong>Easy Ordering</strong>
                        <small>Simple and convenient</small>
                    </div>
                </div>

            </div>

        </div>

    </section>


    <!-- Restaurant Listing Section -->
    <main class="restaurants-section" id="restaurants">

        <div class="section-container">

            <div class="section-heading">

                <div class="heading-copy">
                    <span class="eyebrow">MADE FOR YOUR CRAVINGS ›</span>

                    <h2>Find your next favourite</h2>

                    <p>
                        Explore amazing restaurants, discover new flavours,
                        and find something delicious for every mood.
                    </p>
                </div>

            </div>


            <!-- Category Navigation -->
            <div class="category-list">

                <a class="category active"
                   href="<%= request.getContextPath() %>/restaurants">
                    <span>🍴</span> All Restaurants
                </a>

                <a class="category"
                   href="<%= request.getContextPath() %>/restaurants?category=Pizza">
                    <span>🍕</span> Pizza
                </a>

                <a class="category"
                   href="<%= request.getContextPath() %>/restaurants?category=Burgers">
                    <span>🍔</span> Burgers
                </a>

                <a class="category"
                   href="<%= request.getContextPath() %>/restaurants?category=Healthy">
                    <span>🌿</span> Healthy
                </a>

                <a class="category"
                   href="<%= request.getContextPath() %>/restaurants?category=Asian">
                    <span>🍜</span> Asian
                </a>

                <a class="category"
                   href="<%= request.getContextPath() %>/restaurants?category=Indian">
                    <span>🍛</span> Indian
                </a>

            </div>


            <!-- Dynamic Restaurant Cards -->
            <div class="restaurants-grid">

                <%
                    if (restaurants != null && !restaurants.isEmpty()) {

                        for (Restaurant restaurant : restaurants) {
                %>

                    <a class="restaurant-link"
                       href="<%= request.getContextPath() %>/menu?restaurantId=<%= restaurant.getRestaurant_id() %>">

                        <article class="restaurant-card">

                            <div class="restaurant-image-wrap">

                                <img class="restaurant-img"
                                     src="<%= request.getContextPath() %>/<%= restaurant.getImagepath() %>"
                                     alt="<%= restaurant.getName() %>"
                                     loading="lazy">

                                <div class="image-shade"></div>

                                <span class="image-label">
                                    ✨ Fresh Favourite
                                </span>

                                <span class="image-arrow">↗</span>

                            </div>

                            <div class="restaurant-body">

                                <div class="restaurant-title-row">

                                    <h3 class="restaurant-name">
                                        <%= restaurant.getName() %>
                                    </h3>

                                    <span class="rating">
                                        <span>★</span>
                                        <%= restaurant.getRating() %>
                                    </span>

                                </div>

                                <div class="restaurant-description">
                                    Discover delicious food freshly prepared
                                    for your next meal.
                                </div>

                                <div class="restaurant-meta">

                                    <span>
                                        <span class="meta-icon">◷</span>
                                        <%= restaurant.getDelivery_time() %> min
                                    </span>

                                    <span>
                                        <span class="meta-icon">♨</span>
                                        <%= restaurant.getCuisine_type() %>
                                    </span>

                                </div>

                                <div class="restaurant-address">
                                    <span>⌖</span>
                                    <%= restaurant.getAddress() %>
                                </div>

                                <div class="card-divider"></div>

                                <div class="card-footer">
                                    <span class="delivery-label">
                                        🛵 Delivery available
                                    </span>

                                    <span class="view-menu">
                                        View Menu <span>→</span>
                                    </span>
                                </div>

                            </div>

                        </article>

                    </a>

                <%
                        }

                    } else {
                %>

                    <div class="empty-state">
                        <div class="empty-icon">🍽️</div>
                        <h3>No restaurants found</h3>
                        <p>
                            Our kitchen is getting ready.
                            Please check back soon for delicious options!
                        </p>

                        <a class="primary-btn"
                           href="<%= request.getContextPath() %>/restaurants">
                            Refresh Restaurants →
                        </a>
                    </div>

                <%
                    }
                %>

            </div>

        </div>

    </main>


    <!-- Footer -->
    <footer class="footer">

        <a class="footer-brand"
           href="<%= request.getContextPath() %>/restaurants">
            🍊 Bite<span>Bloom</span>
        </a>

        <p>Fresh food, happy mood. Made for food lovers.</p>

        <div class="footer-links">
            <a href="<%= request.getContextPath() %>/restaurants">Restaurants</a>
            <a href="<%= request.getContextPath() %>/cart">Cart</a>
            <a href="<%= request.getContextPath() %>/signin">Sign In</a>
        </div>

        <div class="footer-bottom">
            &copy; 2026 BiteBloom. All rights reserved.
        </div>

    </footer>

</body>
</html>
