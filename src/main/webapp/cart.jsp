<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.tap.model.Cart" %>

<%@ page import="com.tap.model.CartItem" %>

<%@ page import="com.tap.model.Menu" %>

<%@ page import="com.tap.model.User" %>

<%@ page import="java.util.Collection" %>

<%!
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

<!DOCTYPE html>

<html lang="en">

<head>

       <meta charset="UTF-8">

       <meta name="viewport" content="width=device-width, initial-scale=1.0">

       <title>BiteBloom | My Cart</title>
       
       <link rel="icon"
          type="image/png"
          href="<%= request.getContextPath() %>/images/bitebloom-favicon.png">

       <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">

       <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css">

</head>

<body class="cart-page-body">

<%

       Cart cart = (Cart) session.getAttribute("cart");

       User loggedInUser = (User) session.getAttribute("loggedInUser");

       int cartCount = (cart == null) ? 0 : cart.getTotalItems();

       String continueUrl = request.getContextPath() + "/restaurants";

       if (cart != null && cart.getRestaurantId() != 0) {

           continueUrl = request.getContextPath() + "/menu?restaurantId=" + cart.getRestaurantId();

       }

%>

<header class="navbar">

       <a class="brand" href="<%= request.getContextPath() %>/restaurants" aria-label="BiteBloom home">

           <span class="brand-icon" aria-hidden="true">🍊</span>

           <span class="brand-name">Bite<span>Bloom</span></span>

       </a>

       <nav class="nav-links" aria-label="Main navigation">

           <a href="<%= request.getContextPath() %>/restaurants">

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

               <form class="navbar-search-form" action="<%= request.getContextPath() %>/restaurants" method="get">

                   <span class="restaurant-search-icon" aria-hidden="true">⌕</span>

                   <label class="visually-hidden" for="cart-page-search">Search restaurants or food</label>

                   <input id="cart-page-search" type="search" name="search" placeholder="Search for food or restaurants...">

                   <button type="submit" aria-label="Submit search">→</button>

               </form>

           </details>

           <a href="<%= request.getContextPath() %>/cart" aria-current="page">

               <span class="nav-icon" aria-hidden="true">

                   <svg viewBox="0 0 24 24"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.7 13.4a2 2 0 0 0 2 1.6h9.7a2 2 0 0 0 2-1.6L23 6H6"></path></svg>

               </span>

               <span>Cart</span>

               <span class="cart-count"><%= cartCount %></span>

           </a>

           <% if (loggedInUser != null) { %>

               <a class="signin-link" href="<%= request.getContextPath() %>/profile">

                   <span class="nav-icon" aria-hidden="true">

                       <svg viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"></circle><path d="M5 21v-2a7 7 0 0 1 14 0v2"></path></svg>

                   </span>

                   <span><%= loggedInUser.getName().split(" ")[0] %></span>

               </a>

           <% } else { %>

               <a class="signin-link" href="<%= request.getContextPath() %>/signin">

                   <span class="nav-icon" aria-hidden="true">

                       <svg viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"></circle><path d="M5 21v-2a7 7 0 0 1 14 0v2"></path></svg>

                   </span>

                   <span>Sign In</span>

               </a>

           <% } %>

       </nav>

</header>

<main class="cart-page">

       <section class="cart-hero" aria-labelledby="cart-hero-title">

           <img

               class="cart-hero-image"

               src="https://images.pexels.com/photos/26925529/pexels-photo-26925529.jpeg"

               alt=""

               aria-hidden="true">

           <div class="cart-hero-overlay" aria-hidden="true"></div>

           <div class="cart-hero-copy">

               <p class="cart-eyebrow">Your Cart</p>

               <h1 id="cart-hero-title">Good Food Brings<br class="cart-title-break"> People Together</h1>

               <p class="cart-hero-subtitle">Great food, great company, even better moments.</p>

           </div>

       </section>

       <div class="cart-layout">

           <% if (cart == null || cart.isEmpty()) { %>

               <section class="cart-empty" aria-labelledby="empty-cart-title">

                   <div class="cart-empty-art" role="img" aria-label="Illustration of an empty shopping cart">

                       <svg viewBox="0 0 120 120" aria-hidden="true" focusable="false">

                           <path class="empty-art-spark" d="M78 18v12M72 24h12M94 39v8M90 43h8"></path>

                           <path class="empty-art-cart" d="M17 27h10l9 45a7 7 0 0 0 7 5h37a7 7 0 0 0 6.7-5.1L96 43H34"></path>

                           <path class="empty-art-basket" d="M37 48h51l-6 22H42z"></path>

                           <path class="empty-art-highlight" d="M46 55l3 11M59 55l1 11M72 55l-1 11"></path>

                           <circle class="empty-art-wheel" cx="48" cy="88" r="5"></circle>

                           <circle class="empty-art-wheel" cx="79" cy="88" r="5"></circle>

                           <path class="empty-art-leaf" d="M25 18c6-1 10 2 11 8-7 1-11-2-11-8zM30 27l7-5"></path>

                       </svg>

                       <span class="empty-art-dot empty-art-dot-one" aria-hidden="true"></span>

                       <span class="empty-art-dot empty-art-dot-two" aria-hidden="true"></span>

                   </div>

                   <p class="cart-eyebrow">A Little Room for Something Delicious</p>

                   <h2 id="empty-cart-title">Your cart is empty</h2>

                   <p>Add your favourite dishes and they’ll be waiting here for you.</p>

                   <a class="cart-primary-link" href="<%= request.getContextPath() %>/restaurants">Explore Restaurants <span aria-hidden="true">→</span></a>

               </section>

           <% } else {

               Collection<CartItem> items = cart.getCartItems();

           %>

               <section class="cart-panel" aria-labelledby="my-cart-heading">

                   <div class="cart-panel-heading">

                       <div class="cart-panel-title-wrap">

                           <span class="cart-section-icon" aria-hidden="true">

                               <svg viewBox="0 0 24 24"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.7 13.4a2 2 0 0 0 2 1.6h9.7a2 2 0 0 0 2-1.6L23 6H6"></path></svg>

                           </span>

                           <div>

                               <h2 id="my-cart-heading">My Cart</h2>

                               <span class="cart-items-count"><%= cart.getTotalItems() %> item<%= cart.getTotalItems() == 1 ? "" : "s" %></span>

                           </div>

                       </div>

                       <a class="continue-shopping" href="<%= continueUrl %>">

                           <span aria-hidden="true">←</span> Add More Items

                       </a>

                   </div>

                   <div class="cart-table" role="table" aria-label="Items in your cart">

                       <div class="cart-table-heading" role="row">

                           <span role="columnheader">Item</span>

                           <span role="columnheader">Price</span>

                           <span role="columnheader">Quantity</span>

                           <span role="columnheader">Total</span>

                           <span class="cart-action-heading" role="columnheader"><span class="visually-hidden">Remove item</span></span>

                       </div>

                       <% for (CartItem item : items) {

                           Menu menu = item.getMenu();

                           // Default image is used only when the database path is empty.
                           String imagePath = request.getContextPath() + "/images/menu-default.jpg";
                           String storedImagePath = menu.getImagePath();
                           String contextPath = request.getContextPath();

                           if (storedImagePath != null) {
                               storedImagePath = storedImagePath.trim();

                               if (!storedImagePath.isEmpty()) {
                                   if (storedImagePath.startsWith("https://")
                                           || storedImagePath.startsWith("http://")) {
                                       // External image URL: use it as stored.
                                       imagePath = storedImagePath;
                                   } else if (storedImagePath.equals(contextPath)
                                           || storedImagePath.startsWith(contextPath + "/")) {
                                       // Already contains the BiteBloom context path.
                                       imagePath = storedImagePath;
                                   } else {
                                       // Local application image path.
                                       if (!storedImagePath.startsWith("/")) {
                                           storedImagePath = "/" + storedImagePath;
                                       }
                                       imagePath = contextPath + storedImagePath;
                                   }
                               }
                           }

                       %>

                           <div class="cart-line-item" role="row">

                               <div class="cart-product" role="cell">

                                   <img class="cart-product-image" src="<%= escapeHtml(imagePath) %>" alt="<%= escapeHtml(menu.getItemName()) %>" loading="lazy">

                                   <div class="cart-product-info">

                                       <h3><%= menu.getItemName() %></h3>

                                       <span class="cart-mobile-price">₹<%= menu.getPrice() %> each</span>

                                   </div>

                               </div>

                               <div class="cart-unit-price" role="cell" data-label="Price">₹<%= menu.getPrice() %></div>

                               <div class="cart-quantity-cell" role="cell" data-label="Quantity">

                                   <div class="cart-quantity-control" aria-label="Quantity controls">

                                       <form action="<%= request.getContextPath() %>/cart" method="post" class="cart-quantity-form">

                                           <input type="hidden" name="action" value="decrease">

                                           <input type="hidden" name="menuId" value="<%= menu.getMenu_id() %>">

                                           <input type="hidden" name="source" value="cart">

                                           <button type="submit" class="cart-quantity-btn" aria-label="Decrease <%= escapeHtml(menu.getItemName()) %> quantity">−</button>

                                       </form>

                                       <span class="cart-quantity-value"><%= item.getQuantity() %></span>

                                       <form action="<%= request.getContextPath() %>/cart" method="post" class="cart-quantity-form">

                                           <input type="hidden" name="action" value="increase">

                                           <input type="hidden" name="menuId" value="<%= menu.getMenu_id() %>">

                                           <input type="hidden" name="source" value="cart">

                                           <button type="submit" class="cart-quantity-btn" aria-label="Increase <%= escapeHtml(menu.getItemName()) %> quantity">+</button>

                                       </form>

                                   </div>

                               </div>

                               <div class="cart-line-total" role="cell" data-label="Total">₹<%= item.getSubTotal() %></div>

                               <div class="cart-remove-cell" role="cell">

                                   <form action="<%= request.getContextPath() %>/cart" method="post" class="cart-remove-form">

                                       <input type="hidden" name="action" value="remove">

                                       <input type="hidden" name="menuId" value="<%= menu.getMenu_id() %>">

                                       <input type="hidden" name="source" value="cart">

                                       <button type="submit" class="cart-remove-btn" aria-label="Remove <%= escapeHtml(menu.getItemName()) %> from cart" title="Remove item">

                                           <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 6h18"></path><path d="M8 6V4h8v2"></path><path d="m19 6-1 14H6L5 6"></path><path d="M10 10v6M14 10v6"></path></svg>

                                       </button>

                                   </form>

                               </div>

                           </div>

                       <% } %>

                   </div>

               </section>

               <aside class="cart-summary-panel" aria-labelledby="cart-summary-heading">

                   <div class="cart-summary-heading">

                       <span class="cart-section-icon" aria-hidden="true">

                           <svg viewBox="0 0 24 24"><rect x="5" y="3" width="14" height="18" rx="2"></rect><path d="M9 7h6M9 11h6M9 15h4"></path></svg>

                       </span>

                       <h2 id="cart-summary-heading">Order Summary</h2>

                   </div>

                   <div class="cart-summary-details">

                       <div class="cart-summary-row">

                           <span>Subtotal</span>

                           <strong>₹<%= cart.getGrandTotal() %></strong>

                       </div>

                       <div class="cart-summary-row delivery-row">

                           <span>Delivery Fee</span>

                           <span class="delivery-note">FREE</span>

                       </div>

                       <div class="cart-summary-divider"></div>

                       <div class="cart-summary-row cart-grand-total">

                           <span>Total</span>

                           <strong>₹<%= cart.getGrandTotal() %></strong>

                       </div>

                   </div>

                   <a class="cart-checkout-btn" href="<%= request.getContextPath() %>/checkout">

                       Proceed to Checkout <span aria-hidden="true">→</span>

                   </a>

                   <form action="<%= request.getContextPath() %>/cart" method="post" class="cart-clear-form">

                       <input type="hidden" name="action" value="clear">

                       <input type="hidden" name="source" value="cart">

                       <button type="submit" class="cart-clear-btn">

                           <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 6h18"></path><path d="M8 6V4h8v2"></path><path d="m19 6-1 14H6L5 6"></path><path d="M10 10v6M14 10v6"></path></svg>

                           Clear Cart

                       </button>

                   </form>

               </aside>

           <% } %>

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
