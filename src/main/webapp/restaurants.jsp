<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.User" %>
<%!
    /* Escapes request/database text before writing it into HTML attributes. */
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>
<%
    List<Restaurant> restaurants =
        (List<Restaurant>) request.getAttribute("restaurants");
    String selectedFoodCategory = request.getParameter("foodCategory");
    if (selectedFoodCategory == null) {
        selectedFoodCategory = (String) request.getAttribute("selectedFoodCategory");
    }
    if (selectedFoodCategory == null || selectedFoodCategory.isBlank()) selectedFoodCategory = "all";
    String searchQuery = request.getParameter("q");
    if (searchQuery == null) searchQuery = (String) request.getAttribute("searchQuery");
    if (searchQuery == null) searchQuery = "";

    // CartController stores the current cart in the session under "cart".
    Cart navbarCart = (Cart) session.getAttribute("cart");
    int navbarCartCount = (navbarCart == null) ? 0 : navbarCart.getTotalItems();

    // SigninController stores the authenticated user under "loggedInUser".
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    String navbarUserLabel = "Sign In";
    String navbarAccountHref = request.getContextPath() + "/signin";
    if (loggedInUser != null) {
        String fullName = loggedInUser.getName();
        if (fullName != null && !fullName.trim().isEmpty()) {
            navbarUserLabel = fullName.trim().split("\\s+")[0];
        } else {
            navbarUserLabel = "Account";
        }
        // CHANGE /user if your account/profile servlet uses a different URL.
        navbarAccountHref = request.getContextPath() + "/profile";
    }

    /* Categories use food categories, not restaurant.cuisine_type. */
    String[][] foodCategories = {
        {"Biryani", "https://images.pexels.com/photos/37883423/pexels-photo-37883423.jpeg"},
        {"South Indian", "https://images.unsplash.com/photo-1588644525273-f37b60d78512?w=600"},
        {"North Indian", "https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&amp;fit=crop&amp;w=260&amp;q=80"},
        {"Pizza", "https://images.unsplash.com/photo-1751026044668-c8fb63abaa4d?q=80&w=1170"},
        {"Burger", "https://media.istockphoto.com/id/1297257303/photo/cheeseburger-with-beef-tomato-lettuce-and-onion.jpg"},
        {"Chinese", "https://media.istockphoto.com/id/483137365/photo/asian-chow-mein-noodles.jpg"},
        {"Dosa", "https://media.istockphoto.com/id/1292631356/photo/masala-dosa-a-south-indian-traditional-and-popular-crepe-with-filling-of-a-mixture-of-mashed.jpg"},
        {"Cakes", "https://images.unsplash.com/photo-1606890737304-57a1ca8a5b62?w=600"},
        {"Ice cream", "https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&amp;fit=crop&amp;w=260&amp;q=80"},
        {"Juices", "https://images.unsplash.com/photo-1622597467836-f3285f2131b8?auto=format&amp;fit=crop&amp;w=260&amp;q=80"},
        {"Idly", "https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&amp;fit=crop&amp;w=260&amp;q=80"},
        {"Paratha", "https://media.istockphoto.com/id/618764348/photo/famous-asian-flat-bread-known-as-parathas.jpg"},
        {"Rolls", "https://media.istockphoto.com/id/1438446331/photo/beef-seekh-kebab-wrap-chole-chicken-shawarma-wrap-with-salad-dip-and-sauce-isolated-wooden.jpg"}
    };
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BiteBloom | Restaurants</title>
    <link rel="icon"
          type="image/png"
          href="<%= request.getContextPath() %>/images/bitebloom-favicon.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/common.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/restaurants.css">
</head>
<body>
    <!-- Navbar -->
    <header class="navbar">
        <a class="brand" href="<%= request.getContextPath() %>/restaurants">
            <span class="brand-icon">🍊</span>
            <span class="brand-name">Bite<span>Bloom</span></span>
        </a>
        <nav class="nav-links" aria-label="Main navigation">
            <!-- Home -->
            <a href="<%= request.getContextPath() %>/restaurants" class="home-link">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none" focusable="false">
                        <path d="m3 10 9-7 9 7" />
                        <path d="M5 9v11h14V9" />
                        <path d="M9 20v-6h6v6" />
                    </svg>
                </span>
                <span>Home</span>
            </a>
            <details class="nav-search">
                <summary class="search-toggle">
                    <span class="nav-icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24" fill="none" focusable="false">
                            <circle cx="11" cy="11" r="7" />
                            <path d="m20 20-4-4" />
                        </svg>
                    </span>
                    <span>Search</span>
                </summary>
                <form class="navbar-search-form"
                      action="<%= request.getContextPath() %>/restaurants"
                      method="get" role="search" aria-label="Search restaurants and dishes">
                    <input type="hidden" name="foodCategory"
                           value="<%= escapeHtml(selectedFoodCategory) %>">
                    <label class="visually-hidden" for="navbar-search-input">Search restaurants, dishes or cuisines</label>
                    <span class="restaurant-search-icon" aria-hidden="true">⌕</span>
                    <input id="navbar-search-input" type="search" name="q"
                           value="<%= escapeHtml(searchQuery) %>"
                           placeholder="Search restaurants, dishes or cuisines...">
                    <button type="submit" aria-label="Submit search">→</button>
                </form>
            </details>

            <!-- Count includes all quantities in the session cart. -->
            <a href="<%= request.getContextPath() %>/cart" class="cart-link">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none" focusable="false">
                        <circle cx="9" cy="21" r="1" />
                        <circle cx="20" cy="21" r="1" />
                        <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6" />
                    </svg>
                </span>
                <span>Cart</span>
                <span class="cart-count"><%= navbarCartCount %></span>
            </a>

            <!-- Sign In when logged out; first name when logged in. -->
            <a href="<%= navbarAccountHref %>" class="signin-link"
               aria-label="<%= escapeHtml(navbarUserLabel) %>">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none" focusable="false">
                        <circle cx="12" cy="8" r="4" />
                        <path d="M6 21v-2a6 6 0 0 1 12 0v2" />
                    </svg>
                </span>
                <span><%= escapeHtml(navbarUserLabel) %></span>
            </a>
        </nav>
    </header>
    <!-- Hero Section with Background Video -->
    <section class="hero" id="home">
        <video autoplay muted loop playsinline id="bg-video"
               src="<%= request.getContextPath() %>/videos/backround1_4K.mp4"
               type="video/mp4">
        </video>
        <div class="overlay"></div>
        <div class="hero-content">
            <h1>
                Every Bite,<br>
                Meets <span>Happiness.</span>
            </h1>
            <p>
                Discover your favourite restaurants, enjoy delicious meals,
                and get fresh food delivered straight to your doorstep.
            </p>
            <div class="hero-actions">
                <a href="#restaurants" class="primary-btn">
                    Explore Restaurants <span aria-hidden="true">→</span>
                </a>
                <a href="#restaurants" class="secondary-btn">Discover More</a>
            </div>
            <div class="hero-features">
                <div class="feature">
                    <span class="feature-icon" aria-hidden="true">◷</span>
                    <div>
                        <strong>Fast Delivery</strong>
                        <small>At your doorstep</small>
                    </div>
                </div>
                <div class="feature-divider"></div>
                <div class="feature">
                    <span class="feature-icon" aria-hidden="true">❋</span>
                    <div>
                        <strong>Fresh Food</strong>
                        <small>Serve with care</small>
                    </div>
                </div>
                <div class="feature-divider"></div>
                <div class="feature">
                    <span class="feature-icon" aria-hidden="true">✓</span>
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
            <!-- Three BiteBloom promotional posters -->
            <section class="promo-posters" aria-label="Featured BiteBloom picks">
                <a class="promo-poster promo-poster-biryani"
                   href="<%= request.getContextPath() %>/restaurants?foodCategory=Biryani#restaurants">
                    <div class="promo-poster-copy">
                        <span class="promo-kicker">THE COMFORT CLASSIC</span>
                        <h2>A Feast Worth<br>Craving.</h2>
                        <p>Fragrant, flavour-packed favourites delivered fresh.</p>
                        <span class="promo-cta">Explore Biryani <span aria-hidden="true">↗</span></span>
                    </div>
                    <img class="promo-poster-image"
                         src="<%= request.getContextPath() %>/images/poster-biryani.jpg"
                         alt="Aromatic biryani served in a bowl" loading="lazy">
                    <span class="promo-glow" aria-hidden="true"></span>
                </a>
                <a class="promo-poster promo-poster-burger"
                   href="<%= request.getContextPath() %>/restaurants?foodCategory=Burger#restaurants">
                    <div class="promo-poster-copy">
                        <span class="promo-kicker">BIG BITES. BIG MOOD.</span>
                        <h2>Stacked With<br>Happiness.</h2>
                        <p>Juicy layers, bold flavours, zero boring bites.</p>
                        <span class="promo-cta">Find Your Burger <span aria-hidden="true">↗</span></span>
                    </div>
                    <img class="promo-poster-image"
                         src="<%= request.getContextPath() %>/images/poster-burger.jpg"
                         alt="Juicy burger with fresh toppings" loading="lazy">
                    <span class="promo-glow" aria-hidden="true"></span>
                </a>
                <a class="promo-poster promo-poster-dessert"
                   href="<%= request.getContextPath() %>/restaurants?foodCategory=Cakes#restaurants">
                    <div class="promo-poster-copy">
                        <span class="promo-kicker">A LITTLE SWEET MAGIC</span>
                        <h2>Make Life<br>Extra Sweet.</h2>
                        <p>Save a little room for a delicious treat.</p>
                        <span class="promo-cta">Explore Desserts <span aria-hidden="true">↗</span></span>
                    </div>
                    <img class="promo-poster-image"
                         src="<%= request.getContextPath() %>/images/poster-cake.jpg"
                         alt="Layered chocolate cake" loading="lazy">
                    <span class="promo-glow" aria-hidden="true"></span>
                </a>
            </section>
            <!-- Horizontally scrollable food category rail -->
            <section class="food-discovery" aria-labelledby="food-discovery-title">
                <div class="food-discovery-heading">
                    <div>
                        <span class="eyebrow">A WORLD OF FLAVOUR</span>
                        <h2 id="food-discovery-title">What Are You Craving Today?</h2>
                    </div>
                    <span class="category-scroll-hint" aria-hidden="true">Discover more <span>→</span></span>
                </div>
                <div class="food-category-rail" aria-label="Food categories">
                <div class="food-category-track">
                    <% for (int railCopy = 0; railCopy < 2; railCopy++) {
                           boolean decorativeCopy = railCopy == 1;
                    %>
                    <div class="food-category-group" <%= decorativeCopy ? "aria-hidden=\"true\" inert" : "" %>>
                    <% for (String[] foodCategory : foodCategories) {
                           String categoryName = foodCategory[0];
                           String categoryImage = foodCategory[1];
                           boolean isCategoryActive = categoryName.equalsIgnoreCase(selectedFoodCategory);
                    %>
                        <form class="food-category-form"
                              action="<%= request.getContextPath() %>/restaurants"
                              method="get">
                            <input type="hidden" name="foodCategory" value="<%= categoryName %>">
                            <input type="hidden" name="q" value="<%= escapeHtml(searchQuery) %>">
                            <button type="submit"
                                    class="food-category-card <%= isCategoryActive ? "is-active" : "" %>"
                                    aria-pressed="<%= isCategoryActive %>">
                                <span class="food-category-image-wrap">
                                    <img src="<%= categoryImage %>"
                                         alt="" aria-hidden="true" loading="lazy">
                                </span>
                                <span class="food-category-name"><%= categoryName %></span>
                            </button>
                        </form>
                    <% } %>
                </div>
                    <% } %>
                </div>
            </div>
            </section>
            <div class="section-heading">
                <div class="heading-copy">
                    <span class="eyebrow">MADE FOR YOUR CRAVINGS ›</span>
                    <h2>Find Your Next Favourite</h2>
                </div>
            </div>
            <!-- Dynamic Restaurant Cards -->
            <div class="restaurants-grid">
                <%
                    if (restaurants != null && !restaurants.isEmpty()) {
                        for (Restaurant restaurant : restaurants) {
                            String restaurantImage = restaurant.getImagepath() == null
                                ? ""
                                : restaurant.getImagepath().trim();
                            if (!restaurantImage.isEmpty() && !restaurantImage.startsWith("http://")
                                    && !restaurantImage.startsWith("https://")
                                    && !restaurantImage.startsWith("/")) {
                                restaurantImage = "/" + restaurantImage;
                            }
                %>
                    <a class="restaurant-link"
                       href="<%= request.getContextPath() %>/menu?restaurantId=<%= restaurant.getRestaurant_id() %>">
                        <article class="restaurant-card">
                            <div class="restaurant-image-wrap">
                                <img class="restaurant-img"
                                     src="<%= restaurantImage.startsWith("http://") || restaurantImage.startsWith("https://")
                                         ? escapeHtml(restaurantImage)
                                         : request.getContextPath() + escapeHtml(restaurantImage) %>"
                                     alt="<%= escapeHtml(restaurant.getName()) %>"
                                     loading="lazy">
                                <div class="image-shade"></div>
                                <span class="image-arrow" aria-hidden="true">↗</span>
                            </div>
                            <div class="restaurant-body">
                                <div class="restaurant-title-row">
                                    <h3 class="restaurant-name"><%= escapeHtml(restaurant.getName()) %></h3>
                                    <span class="rating">
                                        <span aria-hidden="true">★</span>
                                        <%= restaurant.getRating() %>
                                    </span>
                                </div>
                                <!-- Location, delivery time and cuisine in one compact row -->
                                <div class="restaurant-meta">
                                    <span class="meta-item address-meta">
                                        <svg class="meta-icon location-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                                            <path d="M20 10.2c0 5.1-8 11.3-8 11.3S4 15.3 4 10.2a8 8 0 1 1 16 0Z"></path>
                                            <circle cx="12" cy="10" r="2.5"></circle>
                                        </svg>
                                        <span class="meta-value"><%= escapeHtml(restaurant.getAddress()) %></span>
                                    </span>
                                    <span class="meta-item delivery-meta">
                                        <span class="meta-icon" aria-hidden="true">◷</span>
                                        <span class="meta-value"><%= restaurant.getDelivery_time() %> mins</span>
                                    </span>
                                    <span class="meta-item cuisine-meta">
                                        <span class="meta-icon" aria-hidden="true">♨</span>
                                        <span class="meta-value"><%= escapeHtml(restaurant.getCuisine_type()) %></span>
                                    </span>
                                </div>
                                <div class="card-divider"></div>
                                <div class="card-footer">
                                    <span class="delivery-label">Delivery available</span>
                                    <span class="view-menu">View Menu <span aria-hidden="true">→</span></span>
                                </div>
                            </div>
                        </article>
                    </a>
                <%
                        }
                    } else {
                %>
                    <div class="empty-state">
                        <div class="empty-icon" aria-hidden="true">🍽️</div>
                        <h3>No restaurants found</h3>
                        <p>
                            Our kitchen is getting ready.
                            Please check back soon for delicious options!
                        </p>
                        <a class="primary-btn" href="<%= request.getContextPath() %>/restaurants">
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
        <a class="footer-brand" href="<%= request.getContextPath() %>/restaurants">
            🍊 Bite<span>Bloom</span>
        </a>
        <p>Fresh food, happy mood. Made for food lovers.</p>
        <div class="footer-links">
            <a href="<%= request.getContextPath() %>/restaurants">Restaurants</a>
            <a href="<%= request.getContextPath() %>/cart">Cart</a>
            <a href="<%= request.getContextPath() %>/orders">Orders</a>
        </div>
        <div class="footer-bottom">
            &copy; 2026 BiteBloom. All rights reserved.
        </div>
    </footer>

</body>
</html>
