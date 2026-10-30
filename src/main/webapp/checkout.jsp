<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="com.tap.model.User" %>
<%@ page import="java.util.Collection" %>

<%!
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
    String contextPath = request.getContextPath();

    Cart cart = (Cart) request.getAttribute("cart");
    if (cart == null) cart = (Cart) session.getAttribute("cart");

    User loggedInUser = (User) request.getAttribute("loggedInUser");
    if (loggedInUser == null) loggedInUser = (User) session.getAttribute("loggedInUser");

    Boolean loginRequired = (Boolean) request.getAttribute("loginRequired");
    String checkoutMessage = (String) session.getAttribute("checkoutMessage");
    if (checkoutMessage != null) session.removeAttribute("checkoutMessage");
    String addressSavedMessage = (String) session.getAttribute("addressSavedMessage");
    if (addressSavedMessage != null) session.removeAttribute("addressSavedMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
    Boolean openAddressForm = (Boolean) request.getAttribute("openAddressForm");

    String formHouseName = (String) request.getAttribute("addressFormHouseName");
    String formStreet = (String) request.getAttribute("addressFormStreet");
    String formCity = (String) request.getAttribute("addressFormCity");
    String formPincode = (String) request.getAttribute("addressFormPincode");
    String formLandmark = (String) request.getAttribute("addressFormLandmark");
    String formAddressType = (String) request.getAttribute("addressFormType");
    if (formHouseName == null) formHouseName = "";
    if (formStreet == null) formStreet = "";
    if (formCity == null) formCity = "";
    if (formPincode == null) formPincode = "";
    if (formLandmark == null) formLandmark = "";
    if (formAddressType == null || formAddressType.isEmpty()) formAddressType = "Home";

    String fullName = loggedInUser != null && loggedInUser.getName() != null ? loggedInUser.getName() : "";
    String phone = loggedInUser != null && loggedInUser.getPhone() != null ? loggedInUser.getPhone() : "";
    String email = loggedInUser != null && loggedInUser.getEmail() != null ? loggedInUser.getEmail() : "";
    String address = loggedInUser != null && loggedInUser.getAddress() != null ? loggedInUser.getAddress().trim() : "";

    int cartCount = cart == null ? 0 : cart.getTotalItems();
    boolean cartHasItems = cart != null && !cart.isEmpty();
    String navbarUserLabel = "Sign In";
    String navbarAccountHref = contextPath + "/signin";
    if (loggedInUser != null) {
        String trimmedName = fullName.trim();
        navbarUserLabel = trimmedName.isEmpty() ? "My Account" : trimmedName.split("\\s+")[0];
        navbarAccountHref = contextPath + "/profile";
    }

    String searchQuery = request.getParameter("q");
    if (searchQuery == null) searchQuery = "";
    String continueUrl = contextPath + "/cart";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BiteBloom | Checkout</title>
    <link rel="icon"
          type="image/png"
          href="<%= request.getContextPath() %>/images/bitebloom-favicon.png">
    <link rel="stylesheet" href="<%= contextPath %>/css/common.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/checkout.css">
</head>
<body class="checkout-page-body">

<header class="navbar">
    <a class="brand" href="<%= contextPath %>/restaurants" aria-label="BiteBloom home">
        <span class="brand-icon" aria-hidden="true">🍊</span>
        <span class="brand-name">Bite<span>Bloom</span></span>
    </a>

    <nav class="nav-links" aria-label="Main navigation">
        <a href="<%= contextPath %>/restaurants" class="home-link">
            <span class="nav-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24" fill="none" focusable="false"><path d="m3 10 9-7 9 7"/><path d="M5 9v11h14V9"/><path d="M9 20v-6h6v6"/></svg>
            </span>
            <span>Home</span>
        </a>

        <details class="nav-search">
            <summary class="search-toggle">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none" focusable="false"><circle cx="11" cy="11" r="7"/><path d="m20 20-4-4"/></svg>
                </span>
                <span>Search</span>
            </summary>
            <form class="navbar-search-form" action="<%= contextPath %>/restaurants" method="get" role="search" aria-label="Search restaurants and dishes">
                <input type="hidden" name="foodCategory" value="all">
                <label class="visually-hidden" for="checkout-navbar-search">Search restaurants, dishes or cuisines</label>
                <span class="restaurant-search-icon" aria-hidden="true">⌕</span>
                <input id="checkout-navbar-search" type="search" name="q" value="<%= escapeHtml(searchQuery) %>" placeholder="Search restaurants, dishes or cuisines...">
                <button type="submit" aria-label="Submit search">→</button>
            </form>
        </details>

        <a href="<%= contextPath %>/cart" class="cart-link" aria-current="page">
            <span class="nav-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24" fill="none" focusable="false"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg>
            </span>
            <span>Cart</span>
            <span class="cart-count"><%= cartCount %></span>
        </a>

        <a href="<%= navbarAccountHref %>" class="signin-link" aria-label="<%= escapeHtml(navbarUserLabel) %>">
            <span class="nav-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24" fill="none" focusable="false"><circle cx="12" cy="8" r="4"/><path d="M6 21v-2a6 6 0 0 1 12 0v2"/></svg>
            </span>
            <span><%= escapeHtml(navbarUserLabel) %></span>
        </a>
    </nav>
</header>

<section class="checkout-hero" aria-labelledby="checkout-hero-title">
    <img
        class="checkout-hero-image"
        src="https://images.pexels.com/photos/37206728/pexels-photo-37206728.jpeg"
        alt=""
        aria-hidden="true">
    <div class="checkout-hero-overlay" aria-hidden="true"></div>
    <div class="checkout-hero-copy">
        <p class="checkout-eyebrow">Almost there</p>
        <h1 id="checkout-hero-title">Complete your order</h1>
        <p class="checkout-hero-subtitle">Confirm your delivery address and choose how you would like to pay.</p>
    </div>
</section>

<main class="checkout-main">
    <div class="checkout-container">
        <nav class="checkout-progress" aria-label="Checkout progress">
            <div class="checkout-step checkout-step-active"><span class="checkout-step-number">1</span><span>Address</span></div>
            <span class="checkout-step-line" aria-hidden="true"></span>
            <div class="checkout-step"><span class="checkout-step-number">2</span><span>Payment</span></div>
            <span class="checkout-step-line" aria-hidden="true"></span>
            <div class="checkout-step"><span class="checkout-step-number">3</span><span>Confirmation</span></div>
        </nav>

        <% if (addressSavedMessage != null && !addressSavedMessage.trim().isEmpty()) { %>
            <div class="checkout-alert checkout-alert-success" role="status"><%= escapeHtml(addressSavedMessage) %></div>
        <% } %>
        <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>
            <div class="checkout-alert checkout-alert-error" role="alert"><%= escapeHtml(errorMessage) %></div>
        <% } %>

        <form id="checkout-form" class="checkout-grid" action="<%= contextPath %>/checkout" method="post">
            <div class="checkout-details-column">
                <section class="checkout-section" aria-labelledby="delivery-address-title">
                    <div class="checkout-section-heading">
                        <span class="checkout-section-icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24" fill="none" focusable="false"><path d="M20 10.2c0 5.1-8 11.3-8 11.3S4 15.3 4 10.2a8 8 0 1 1 16 0Z"/><circle cx="12" cy="10" r="2.5"/></svg>
                        </span>
                        <h2 id="delivery-address-title">Delivery Address</h2>
                    </div>

                    <div class="saved-address-card">
                        <span class="saved-address-radio" aria-hidden="true"></span>
                        <div class="saved-address-copy">
                            <strong><%= fullName.isEmpty() ? "Delivery recipient" : escapeHtml(fullName) %></strong>
                            <% if (!phone.isEmpty()) { %>
                                <p class="saved-address-phone"><%= escapeHtml(phone) %></p>
                            <% } %>
                            <p><%= address.isEmpty() ? "No saved address yet. Add your delivery address below." : escapeHtml(address) %></p>
                        </div>
                        <span class="saved-address-tag"><%= address.isEmpty() ? "Required" : "Current" %></span>
                    </div>

                    <!-- Native HTML disclosure: new-address fields remain closed until clicked. -->
                    <details class="checkout-address-details" <%= Boolean.TRUE.equals(openAddressForm) ? "open" : "" %>>
                        <summary><span class="address-add-icon" aria-hidden="true">+</span><span>Add New Address</span></summary>
                        <div class="checkout-address-editor">
                            <p class="checkout-field-note">Enter your new delivery address below.</p>
                            <div class="checkout-form-grid">
                                <div class="checkout-field">
                                    <label for="houseName">House / Flat / Building No.</label>
                                    <input id="houseName" class="checkout-input" type="text" name="houseName" value="<%= escapeHtml(formHouseName) %>" placeholder="e.g. Flat 402">
                                </div>
                                <div class="checkout-field">
                                    <label for="street">Street / Area</label>
                                    <input id="street" class="checkout-input" type="text" name="street" value="<%= escapeHtml(formStreet) %>" placeholder="e.g. BTM 2nd Stage">
                                </div>
                                <div class="checkout-field">
                                    <label for="city">City</label>
                                    <input id="city" class="checkout-input" type="text" name="city" value="<%= escapeHtml(formCity) %>" placeholder="e.g. Bengaluru">
                                </div>
                                <div class="checkout-field">
                                    <label for="pincode">Pincode</label>
                                    <input id="pincode" class="checkout-input" type="text" name="pincode" value="<%= escapeHtml(formPincode) %>" inputmode="numeric" maxlength="6" pattern="[0-9]{6}" placeholder="6-digit pincode">
                                </div>
                                <div class="checkout-field">
                                    <label for="landmark">Landmark <span>(optional)</span></label>
                                    <input id="landmark" class="checkout-input" type="text" name="landmark" value="<%= escapeHtml(formLandmark) %>" placeholder="Nearby landmark">
                                </div>
                                <div class="checkout-field">
                                    <label for="addressType">Address Type</label>
                                    <select id="addressType" class="checkout-input" name="addressType">
                                        <option value="Home" <%= "Home".equals(formAddressType) ? "selected" : "" %>>Home</option>
                                        <option value="Work" <%= "Work".equals(formAddressType) ? "selected" : "" %>>Work</option>
                                        <option value="Other" <%= "Other".equals(formAddressType) ? "selected" : "" %>>Other</option>
                                    </select>
                                </div>
                            </div>
                            <button class="checkout-save-address" type="submit" name="action" value="saveAddress">Save Address</button>
                        </div>
                    </details>

                    <!-- Backward-compatible parameter for the current checkout servlet. -->
                    <input type="hidden" name="deliveryAddress" value="<%= escapeHtml(address) %>">
                </section>

                <section class="checkout-section" aria-labelledby="payment-method-title">
                    <div class="checkout-section-heading">
                        <span class="checkout-section-icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24" fill="none" focusable="false"><rect x="3" y="5" width="18" height="14" rx="2"/><path d="M3 10h18M7 15h3"/></svg>
                        </span>
                        <h2 id="payment-method-title">Payment Method</h2>
                    </div>
                    <p class="checkout-section-description">Choose your preferred payment method.</p>

                    <div class="checkout-payment-options">
                        <label class="checkout-payment-option">
                            <input type="radio" name="paymentMethod" value="COD" checked>
                            <span class="payment-option-icon" aria-hidden="true">
                                <svg viewBox="0 0 24 24" fill="none" focusable="false"><rect x="3" y="6" width="18" height="13" rx="2"/><path d="M7 10h.01M17 15h.01M12 10v5m-2-3h4"/></svg>
                            </span>
                            <span class="payment-option-copy"><strong>Cash on Delivery</strong><small>Pay when your order arrives</small></span>
                            <span class="payment-option-check" aria-hidden="true"></span>
                        </label>
                        <label class="checkout-payment-option">
                            <input type="radio" name="paymentMethod" value="UPI" disabled aria-disabled="true">
                            <span class="payment-option-icon payment-upi" aria-hidden="true">UPI</span>
                            <span class="payment-option-copy"><strong>UPI Payment</strong><small>Not available for now.</small></span>
                            <span class="payment-option-check" aria-hidden="true"></span>
                        </label>
                        <label class="checkout-payment-option">
                            <input type="radio" name="paymentMethod" value="NET_BANKING" disabled aria-disabled="true">
                            <span class="payment-option-icon" aria-hidden="true">
                                <svg viewBox="0 0 24 24" fill="none" focusable="false"><path d="M3 9h18L12 4 3 9Z M5 10v8m4-8v8m6-8v8m4-8v8M3 20h18"/></svg>
                            </span>
                            <span class="payment-option-copy"><strong>Net Banking</strong><small>Not available for now.</small></span>
                            <span class="payment-option-check" aria-hidden="true"></span>
                        </label>
                        <label class="checkout-payment-option">
                            <input type="radio" name="paymentMethod" value="CARD" disabled aria-disabled="true">
                            <span class="payment-option-icon" aria-hidden="true">
                                <svg viewBox="0 0 24 24" fill="none" focusable="false"><rect x="2.5" y="5" width="19" height="14" rx="2"/><path d="M3 10h18M7 15h4"/></svg>
                            </span>
                            <span class="payment-option-copy"><strong>Credit / Debit Card</strong><small>Not available for now.</small></span>
                            <span class="payment-option-check" aria-hidden="true"></span>
                        </label>
                    </div>
                </section>

                <section class="checkout-section checkout-instructions-section" aria-labelledby="instructions-title">
                    <div class="checkout-section-heading">
                        <span class="checkout-section-icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24" fill="none" focusable="false"><path d="M7 3h10a2 2 0 0 1 2 2v16l-7-4-7 4V5a2 2 0 0 1 2-2Z"/><path d="M9 8h6M9 12h6"/></svg>
                        </span>
                        <h2 id="instructions-title">Special Instructions</h2>
                    </div>
                    <label class="visually-hidden" for="specialInstructions">Special instructions for your order</label>
                    <textarea id="specialInstructions" class="checkout-textarea" name="specialInstructions" rows="3" placeholder="Any special request? (e.g. no onions, extra spicy...) "></textarea>
                </section>
            </div>

            <aside class="checkout-summary" aria-labelledby="order-summary-title">
                <div class="checkout-summary-heading">
                    <span class="checkout-section-icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24" fill="none" focusable="false"><rect x="5" y="3" width="14" height="18" rx="2"/><path d="M9 8h6M9 12h6M9 16h4"/></svg>
                    </span>
                    <h2 id="order-summary-title">Order Summary</h2>
                </div>

                <div class="checkout-summary-items">
                    <% if (cartHasItems) {
                           Collection<CartItem> items = cart.getCartItems();
                           for (CartItem item : items) {
                               if (item == null || item.getMenu() == null) continue;

                               // Resolve each cart item's image from the imagepath stored in the menu table.
                               String itemImageUrl = contextPath + "/images/menu-default.jpg";
                               String storedImagePath = item.getMenu().getImagePath();

                               if (storedImagePath != null) {
                                   storedImagePath = storedImagePath.trim();

                                   if (!storedImagePath.isEmpty()) {
                                       if (storedImagePath.startsWith("https://")
                                               || storedImagePath.startsWith("http://")) {
                                           // External image URL: use it directly.
                                           itemImageUrl = storedImagePath;
                                       } else if (storedImagePath.equals(contextPath)
                                               || storedImagePath.startsWith(contextPath + "/")) {
                                           // Context path is already included.
                                           itemImageUrl = storedImagePath;
                                       } else {
                                           // Local application image: add the context path.
                                           if (!storedImagePath.startsWith("/")) {
                                               storedImagePath = "/" + storedImagePath;
                                           }
                                           itemImageUrl = contextPath + storedImagePath;
                                       }
                                   }
                               }
                    %>
                        <div class="checkout-summary-item">
                            <img src="<%= escapeHtml(itemImageUrl) %>" alt="<%= escapeHtml(item.getMenu().getItemName()) %>" loading="lazy">
                            <div class="checkout-summary-item-copy">
                                <strong><%= escapeHtml(item.getMenu().getItemName()) %></strong>
                                <span>Qty <%= item.getQuantity() %></span>
                            </div>
                            <strong class="checkout-summary-price">₹<%= item.getSubTotal() %></strong>
                        </div>
                    <%     }
                       } else { %>
                        <p class="checkout-empty-summary">Your cart is empty.</p>
                    <% } %>
                </div>

                <div class="checkout-total-lines">
                    <div class="checkout-total-row"><span>Subtotal</span><strong>₹<%= cartHasItems ? cart.getGrandTotal() : 0 %></strong></div>
                    <div class="checkout-total-row"><span>Delivery Fee</span><strong class="checkout-free-delivery">FREE</strong></div>
                    <div class="checkout-total-divider"></div>
                    <div class="checkout-total-row checkout-grand-total"><span>Total</span><strong>₹<%= cartHasItems ? cart.getGrandTotal() : 0 %></strong></div>
                </div>

                <button class="checkout-submit-button" type="submit" <%= cartHasItems ? "" : "disabled" %>>Continue to Payment <span aria-hidden="true">→</span></button>
                <% if (loggedInUser != null) { %>
                    <p class="checkout-secure-note"><span aria-hidden="true">♢</span> Your order details are handled securely.</p>
                <% } %>
                <a class="checkout-back-link" href="<%= continueUrl %>">← Return to Cart</a>
            </aside>
        </form>
    </div>
</main>

<footer class="footer">
    <a class="footer-brand" href="<%= contextPath %>/restaurants">🍊 Bite<span>Bloom</span></a>
    <p>Fresh food, happy mood. Made for food lovers.</p>
    <div class="footer-links">
        <a href="<%= contextPath %>/restaurants">Restaurants</a>
        <a href="<%= contextPath %>/cart">Cart</a>
        <a href="<%= contextPath %>/orders">Orders</a>
        <a href="<%= contextPath %>/profile">My Account</a>
    </div>
    <div class="footer-bottom">&copy; 2026 BiteBloom. All rights reserved.</div>
</footer>

</body>
</html>
