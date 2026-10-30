<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>

<%@ page import="com.tap.model.Restaurant" %>

<%@ page import="com.tap.model.Menu" %>

<%@ page import="com.tap.model.Cart" %>

<%@ page import="com.tap.model.CartItem" %>

<%@ page import="com.tap.model.User" %>

<%!

    // Escape dynamic values before rendering them into HTML text or attributes.

    private String escapeHtml(String value) {

        if (value == null) {

            return "";

        }

        return value.replace("&", "&amp;")

                    .replace("<", "&lt;")

                    .replace(">", "&gt;")

                    .replace("\"", "&quot;")

                    .replace("'", "&#39;");

    }

%>

<%

    String contextPath = request.getContextPath();

    // Data supplied by MenuController (or the controller mapped to /menu).

    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");

    List<Menu> menus = (List<Menu>) request.getAttribute("menus");

    // Session state used by the navbar and item quantity controls.

    Cart cart = (Cart) session.getAttribute("cart");

    User loggedInUser = (User) session.getAttribute("loggedInUser");

    int navbarCartCount = (cart == null) ? 0 : cart.getTotalItems();

    // Show only the first name in the account link.

    String userFirstName = "";

    if (loggedInUser != null && loggedInUser.getName() != null) {

        String fullName = loggedInUser.getName().trim();

        if (!fullName.isEmpty()) {

            userFirstName = fullName.split("\\s+")[0];

        }

    }

    // Search values are page-local; they do not depend on variables in restaurants.jsp.

    Object selectedCategoryAttribute = request.getAttribute("selectedFoodCategory");

    String selectedFoodCategory = request.getParameter("foodCategory");

    if (selectedFoodCategory == null || selectedFoodCategory.trim().isEmpty()) {

        selectedFoodCategory = (selectedCategoryAttribute == null)

                ? "all" : selectedCategoryAttribute.toString();

    }

    Object searchQueryAttribute = request.getAttribute("searchQuery");

    String searchQuery = request.getParameter("q");

    if (searchQuery == null) {

        searchQuery = (searchQueryAttribute == null) ? "" : searchQueryAttribute.toString();

    }

    String navbarAccountHref = contextPath + ((loggedInUser == null) ? "/signin" : "/profile");

    String navbarUserLabel = (loggedInUser == null) ? "Sign In"

            : (userFirstName.isEmpty() ? "My Account" : userFirstName);

    // Normalize the restaurant image path while supporting absolute image URLs.

    String restaurantImageUrl = null;

    if (restaurant != null && restaurant.getImagepath() != null) {

        String rawRestaurantImage = restaurant.getImagepath().trim();

        if (!rawRestaurantImage.isEmpty()) {

            if (rawRestaurantImage.startsWith("http://") || rawRestaurantImage.startsWith("https://")) {

                restaurantImageUrl = rawRestaurantImage;

            } else {

                if (!rawRestaurantImage.startsWith("/")) {

                    rawRestaurantImage = "/" + rawRestaurantImage;

                }

                restaurantImageUrl = contextPath + rawRestaurantImage;

            }

        }

    }

%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title><%= restaurant != null ? escapeHtml(restaurant.getName()) + " | BiteBloom Menu" : "BiteBloom | Menu" %></title>
    
    <link rel="icon"
          type="image/png"
          href="<%= request.getContextPath() %>/images/bitebloom-favicon.png">

    <link rel="stylesheet" href="<%= contextPath %>/css/common.css">

    <link rel="stylesheet" href="<%= contextPath %>/css/menu.css">

</head>

<body class="menu-page-body">

    <!-- Navbar markup remains in this page; all navbar CSS is in common.css. -->

    <header class="navbar">

        <a class="brand" href="<%= contextPath %>/restaurants" aria-label="BiteBloom home">

            <span class="brand-icon" aria-hidden="true">🍊</span>

            <span class="brand-name">Bite<span>Bloom</span></span>

        </a>

        <nav class="nav-links" aria-label="Main navigation">

            <a href="<%= contextPath %>/restaurants" class="home-link">

                <span class="nav-icon" aria-hidden="true">

                    <svg viewBox="0 0 24 24" fill="none" focusable="false">

                        <path d="m3 10 9-7 9 7" />

                        <path d="M5 9v11h14V9" />

                        <path d="M9 20v-6h6v6" />

                    </svg>

                </span>

                <span>Home</span>

            </a>

            <!-- Native HTML disclosure: no JavaScript required. -->

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

                      action="<%= contextPath %>/restaurants"

                      method="get" role="search" aria-label="Search restaurants and dishes">

                    <input type="hidden" name="foodCategory" value="<%= escapeHtml(selectedFoodCategory) %>">

                    <label class="visually-hidden" for="navbar-search-input">Search restaurants, dishes or cuisines</label>

                    <span class="restaurant-search-icon" aria-hidden="true">⌕</span>

                    <input id="navbar-search-input" type="search" name="q"

                           value="<%= escapeHtml(searchQuery) %>"

                           placeholder="Search restaurants, dishes or cuisines...">

                    <button type="submit" aria-label="Submit search">→</button>

                </form>

            </details>

            <a href="<%= contextPath %>/cart" class="cart-link">

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

               aria-label="<%= escapeHtml(loggedInUser == null ? "Sign In" : "Open account for " + navbarUserLabel) %>">

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

    <main class="menu-page">

        <!-- Restaurant banner -->

        <% if (restaurant != null) { %>

            <section class="restaurant-banner" aria-labelledby="restaurant-title">

                <% if (restaurantImageUrl != null) { %>

                    <img class="restaurant-banner-image"

                         src="<%= escapeHtml(restaurantImageUrl) %>"

                         alt="" aria-hidden="true">

                <% } %>

                <div class="restaurant-banner-overlay"></div>

                <div class="restaurant-banner-content">

                    <div class="restaurant-banner-copy">

                        <span class="banner-eyebrow">MADE FRESH. MADE FOR YOU.</span>

                        <h1 id="restaurant-title"><%= escapeHtml(restaurant.getName()) %></h1>

                        <p class="restaurant-subtitle">Discover favourites made with care.</p>

                    </div>

                    <div class="restaurant-meta-row">

                        <span class="rating-pill"><span aria-hidden="true">★</span> <%= restaurant.getRating() %></span>

                        <span class="meta-pill"><%= escapeHtml(restaurant.getCuisine_type()) %></span>

                        <% if (restaurant.getAddress() != null && !restaurant.getAddress().trim().isEmpty()) { %>

                            <span class="meta-pill address-pill"><span aria-hidden="true"></span> <%= escapeHtml(restaurant.getAddress()) %></span>

                        <% } %>

                        <% if (restaurant.isIs_active()) { %>

                            <span class="meta-pill open-pill"><span class="status-dot"></span> Open now</span>

                        <% } else { %>

                            <span class="meta-pill closed-pill"><span class="status-dot"></span> Currently closed</span>

                        <% } %>

                    </div>

                </div>

            </section>

        <% } else { %>

            <section class="restaurant-banner restaurant-banner-fallback">

                <div class="restaurant-banner-overlay"></div>

                <div class="restaurant-banner-content">

                    <span class="banner-eyebrow">BITEBLOOM MENU</span>

                    <h1>Discover something delicious</h1>

                </div>

            </section>

        <% } %>

        <!-- Full-width menu list -->

        <div class="menu-content">

            <section class="menu-section" aria-labelledby="menu-section-title">

                <div class="menu-section-heading">

                    <div>

                        <span class="section-eyebrow">CURATED FOR YOUR CRAVINGS</span>

                        <h2 id="menu-section-title">Our Menu</h2>

                        <p>Choose your favourites and make your next bite special.</p>

                    </div>

                    <% if (menus != null && !menus.isEmpty()) { %>

                        <span class="menu-item-count"><%= menus.size() %> items</span>

                    <% } %>

                </div>

                <% if (menus != null && !menus.isEmpty() && restaurant != null) { %>

                    <div class="menu-list">

                        <% for (Menu menu : menus) {

                               int menuId = menu.getMenu_id();

                               int quantity = 0;

                               if (cart != null && cart.getItems() != null && cart.getItems().containsKey(menuId)) {

                                   CartItem cartItem = cart.getItems().get(menuId);

                                   if (cartItem != null) {

                                       quantity = cartItem.getQuantity();

                                   }

                               }

                               String dishType = menu.getDishType();

                               boolean isVeg = dishType != null && dishType.equalsIgnoreCase("veg");

                               // Use the image path stored for this menu item in the database.
                               String itemImageUrl = contextPath + "/images/menu-default.jpg";
                               String storedImagePath = menu.getImagePath();

                               if (storedImagePath != null) {
                                   storedImagePath = storedImagePath.trim();

                                   if (!storedImagePath.isEmpty()) {
                                       if (storedImagePath.startsWith("https://")
                                               || storedImagePath.startsWith("http://")) {
                                           // Absolute remote URL: use it directly.
                                           itemImageUrl = storedImagePath;
                                       } else if (storedImagePath.equals(contextPath)
                                               || storedImagePath.startsWith(contextPath + "/")) {
                                           // Already includes the application context path.
                                           itemImageUrl = storedImagePath;
                                       } else {
                                           // Local app-relative path, such as images/menu-1.jpg.
                                           if (!storedImagePath.startsWith("/")) {
                                               storedImagePath = "/" + storedImagePath;
                                           }
                                           itemImageUrl = contextPath + storedImagePath;
                                       }
                                   }
                               }

                        %>

                            <article class="menu-item">

                                <div class="item-image-wrap">

                                    <img class="item-image"

                                         src="<%= escapeHtml(itemImageUrl) %>"

                                         alt="<%= escapeHtml(menu.getItemName()) %>"

                                         loading="lazy">

                                </div>

                                <div class="item-left">

                                    <div class="item-title-line">

                                        <span class="type-icon <%= isVeg ? "veg-icon" : "nonveg-icon" %>"

                                              role="img"

                                              aria-label="<%= isVeg ? "Vegetarian" : "Non-vegetarian" %>"></span>

                                        <div class="item-title-copy">

                                            <h3 class="item-name"><%= escapeHtml(menu.getItemName()) %></h3>

                                            <div class="item-price">₹<%= menu.getPrice() %></div>

                                        </div>

                                    </div>

                                    <% if (menu.getDescription() != null && !menu.getDescription().trim().isEmpty()) { %>

                                        <p class="item-desc"><%= escapeHtml(menu.getDescription()) %></p>

                                    <% } %>

                                </div>

                                <div class="item-right">

                                    <div class="cart-control">

                                        <% if (quantity <= 0) { %>

                                            <form action="<%= contextPath %>/cart" method="post">

                                                <input type="hidden" name="action" value="add">

                                                <input type="hidden" name="menuId" value="<%= menuId %>">

                                                <input type="hidden" name="restaurantId" value="<%= restaurant.getRestaurant_id() %>">

                                                <input type="hidden" name="source" value="menu">

                                                <button type="submit" class="add-btn">ADD</button>

                                            </form>

                                        <% } else { %>

                                            <div class="qty-box" aria-label="Quantity for <%= escapeHtml(menu.getItemName()) %>">

                                                <form action="<%= contextPath %>/cart" method="post" class="qty-form">

                                                    <input type="hidden" name="action" value="decrease">

                                                    <input type="hidden" name="menuId" value="<%= menuId %>">

                                                    <input type="hidden" name="restaurantId" value="<%= restaurant.getRestaurant_id() %>">

                                                    <input type="hidden" name="source" value="menu">

                                                    <button type="submit" class="qty-btn" aria-label="Decrease quantity">−</button>

                                                </form>

                                                <span class="qty-value"><%= quantity %></span>

                                                <form action="<%= contextPath %>/cart" method="post" class="qty-form">

                                                    <input type="hidden" name="action" value="increase">

                                                    <input type="hidden" name="menuId" value="<%= menuId %>">

                                                    <input type="hidden" name="restaurantId" value="<%= restaurant.getRestaurant_id() %>">

                                                    <input type="hidden" name="source" value="menu">

                                                    <button type="submit" class="qty-btn" aria-label="Increase quantity">+</button>

                                                </form>

                                            </div>

                                        <% } %>

                                    </div>

                                </div>

                            </article>

                        <% } %>

                    </div>

                <% } else if (restaurant == null) { %>

                    <div class="empty-state">

                        <span class="empty-state-icon" aria-hidden="true">🍽️</span>

                        <h3>Restaurant details unavailable</h3>

                        <p>Please return to the restaurants page and choose a restaurant to view its menu.</p>

                        <a class="menu-primary-link" href="<%= contextPath %>/restaurants">Explore restaurants <span aria-hidden="true">→</span></a>

                    </div>

                <% } else { %>

                    <div class="empty-state">

                        <span class="empty-state-icon" aria-hidden="true">🍽️</span>

                        <h3>No menu items yet</h3>

                        <p>This restaurant hasn't added menu items yet. Please check back soon.</p>

                    </div>

                <% } %>

            </section>

        </div>

    </main>

    <footer class="footer">

        <a class="footer-brand" href="<%= contextPath %>/restaurants">🍊 Bite<span>Bloom</span></a>

        <p>Fresh food, happy mood. Made for food lovers.</p>

        <div class="footer-links">

            <a href="<%= contextPath %>/restaurants">Restaurants</a>

            <a href="<%= contextPath %>/cart">Cart</a>

            <a href="<%= contextPath %>/orders">Orders</a>

        </div>

        <div class="footer-bottom">&copy; 2026 BiteBloom. All rights reserved.</div>

    </footer>

</body>

</html>
