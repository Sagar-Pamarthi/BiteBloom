<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BiteBloom | Profile</title>
    <link rel="icon"
          type="image/png"
          href="<%= request.getContextPath() %>/images/bitebloom-favicon.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/common.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/profile.css">
</head>
<body class="profile-page-body">
<%
    String contextPath = request.getContextPath();
    User loggedInUser = (User) request.getAttribute("profileUser");
    if (loggedInUser == null) {
        loggedInUser = (User) session.getAttribute("loggedInUser");
    }
    if (loggedInUser == null) {
        response.sendRedirect(contextPath + "/signin");
        return;
    }

    Cart cart = (Cart) session.getAttribute("cart");
    int cartCount = cart == null ? 0 : cart.getTotalItems();
    String fullName = loggedInUser.getName() == null ? "BiteBloom User" : loggedInUser.getName().trim();
    if (fullName.isEmpty()) fullName = "BiteBloom User";
    String firstName = fullName.split("\\s+")[0];
    String initial = fullName.substring(0, 1).toUpperCase(Locale.ROOT);
    String email = loggedInUser.getEmail() == null ? "" : loggedInUser.getEmail();
    String phone = loggedInUser.getPhone() == null ? "" : loggedInUser.getPhone();
    String address = loggedInUser.getAddress() == null ? "" : loggedInUser.getAddress();
    String createdDateDisplay = "Not available";
    	if (loggedInUser.getCreatedDate() != null) {
        	createdDateDisplay = new SimpleDateFormat("dd MMM yyyy")
                	.format(loggedInUser.getCreatedDate());
    	}
    String editField = (String) request.getAttribute("editField");
    if (editField == null) editField = "";
    int totalOrderCount = request.getAttribute("totalOrderCount") == null ? -1 : ((Integer) request.getAttribute("totalOrderCount")).intValue();
    String updated = request.getParameter("updated");
    String error = request.getParameter("error");
%>
<%!
    private String htmlEscape(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<!-- Shared BiteBloom navbar: common.css owns all navbar styling. -->
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
                <label class="visually-hidden" for="profile-page-search">Search restaurants or food</label>
                <input id="profile-page-search" type="search" name="search" placeholder="Search for food or restaurants...">
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

        <a class="signin-link" href="<%= contextPath %>/profile" aria-current="page" aria-label="Your profile">
            <span class="nav-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"></circle><path d="M5 21v-2a7 7 0 0 1 14 0v2"></path></svg>
            </span>
            <span><%= htmlEscape(firstName) %></span>
        </a>
    </nav>
</header>

<main class="profile-page">
    <!-- Same dimensions and overlay structure as the current Orders hero. -->
    <section class="profile-hero" aria-labelledby="profile-hero-title">
        <img class="profile-hero-image" src="https://images.pexels.com/photos/37338696/pexels-photo-37338696.jpeg" 
        	alt="" aria-hidden="true">
        <div class="profile-hero-overlay" aria-hidden="true"></div>
        <div class="profile-hero-copy">
            <div class="profile-hero-text">
                <p class="profile-eyebrow">YOUR BITEBLOOM ACCOUNT</p>
                <h1 id="profile-hero-title">My Profile</h1>
                <p class="profile-hero-subtitle">Your details, your food journey, all in one place.</p>
            </div>
            <form class="profile-signout-form" action="<%= contextPath %>/profile" method="post">
                <input type="hidden" name="action" value="signout">
                <button class="profile-signout-btn" type="submit">
                    <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M10 17l5-5-5-5"></path><path d="M15 12H3"></path><path d="M12 3h6a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-6"></path></svg>
                    Sign Out
                </button>
            </form>
        </div>
    </section>

    <section class="profile-content" aria-label="Account profile">
        <% if ("true".equals(updated)) { %>
            <div class="profile-notice profile-notice-success" role="status">Your profile information has been updated successfully.</div>
        <% } else if ("invalid".equals(error)) { %>
            <div class="profile-notice profile-notice-error" role="alert">Please enter a valid value for the selected field.</div>
        <% } else if ("save".equals(error)) { %>
            <div class="profile-notice profile-notice-error" role="alert">That change could not be saved. Check whether the email address is already registered, then try again.</div>
        <% } %>

        <div class="profile-layout">
            <section class="profile-info-card" aria-labelledby="personal-info-title">
                <div class="profile-card-heading">
                    <div class="profile-avatar" aria-hidden="true">
                        <span><%= htmlEscape(initial) %></span>
                    </div>
                    <div class="profile-heading-copy">
                        <p class="profile-section-eyebrow">ACCOUNT DETAILS</p>
                        <h2 id="personal-info-title">Personal Information</h2>
                        <p>Keep your contact information up to date.</p>
                    </div>
                </div>

                <div class="profile-fields">
                    <!-- Name -->
                    <div class="profile-field-row">
                        <% if ("name".equals(editField)) { %>
                            <form class="profile-edit-form" action="<%= contextPath %>/profile" method="post">
                                <input type="hidden" name="action" value="updateProfileField">
                                <input type="hidden" name="field" value="name">
                                <label for="profile-name-input">Full Name</label>
                                <input id="profile-name-input" type="text" name="value" value="<%= htmlEscape(fullName.equals("BiteBloom User") && (loggedInUser.getName() == null || loggedInUser.getName().trim().isEmpty()) ? "" : loggedInUser.getName()) %>" maxlength="100" minlength="2" autocomplete="name" required>
                                <div class="profile-edit-actions">
                                    <a class="profile-cancel-link" href="<%= contextPath %>/profile">Cancel</a>
                                    <button class="profile-save-btn" type="submit">Save Changes</button>
                                </div>
                            </form>
                        <% } else { %>
                            <div class="profile-field-content">
                                <span class="profile-field-label">Full Name</span>
                                <strong class="profile-field-value"><%= htmlEscape(fullName) %></strong>
                            </div>
                            <a class="profile-edit-link" href="<%= contextPath %>/profile?edit=name">Edit</a>
                        <% } %>
                    </div>

                    <!-- Email -->
                    <div class="profile-field-row">
                        <% if ("email".equals(editField)) { %>
                            <form class="profile-edit-form" action="<%= contextPath %>/profile" method="post">
                                <input type="hidden" name="action" value="updateProfileField">
                                <input type="hidden" name="field" value="email">
                                <label for="profile-email-input">Email Address</label>
                                <input id="profile-email-input" type="email" name="value" value="<%= htmlEscape(email) %>" maxlength="254" autocomplete="email" required>
                                <div class="profile-edit-actions">
                                    <a class="profile-cancel-link" href="<%= contextPath %>/profile">Cancel</a>
                                    <button class="profile-save-btn" type="submit">Save Changes</button>
                                </div>
                            </form>
                        <% } else { %>
                            <div class="profile-field-content">
                                <span class="profile-field-label">Email Address</span>
                                <strong class="profile-field-value"><%= email.trim().isEmpty() ? "Not added" : htmlEscape(email) %></strong>
                            </div>
                            <a class="profile-edit-link" href="<%= contextPath %>/profile?edit=email">Edit</a>
                        <% } %>
                    </div>

                    <!-- Phone -->
                    <div class="profile-field-row">
                        <% if ("phone".equals(editField)) { %>
                            <form class="profile-edit-form" action="<%= contextPath %>/profile" method="post">
                                <input type="hidden" name="action" value="updateProfileField">
                                <input type="hidden" name="field" value="phone">
                                <label for="profile-phone-input">Phone Number</label>
                                <input id="profile-phone-input" type="tel" name="value" value="<%= htmlEscape(phone) %>" maxlength="20" minlength="7" autocomplete="tel" required>
                                <div class="profile-edit-actions">
                                    <a class="profile-cancel-link" href="<%= contextPath %>/profile">Cancel</a>
                                    <button class="profile-save-btn" type="submit">Save Changes</button>
                                </div>
                            </form>
                        <% } else { %>
                            <div class="profile-field-content">
                                <span class="profile-field-label">Phone Number</span>
                                <strong class="profile-field-value"><%= phone.trim().isEmpty() ? "Not added" : htmlEscape(phone) %></strong>
                            </div>
                            <a class="profile-edit-link" href="<%= contextPath %>/profile?edit=phone">Edit</a>
                        <% } %>
                    </div>

                    <!-- Address replaces Date of Birth -->
                    <div class="profile-field-row profile-address-row">
                        <% if ("address".equals(editField)) { %>
                            <form class="profile-edit-form" action="<%= contextPath %>/profile" method="post">
                                <input type="hidden" name="action" value="updateProfileField">
                                <input type="hidden" name="field" value="address">
                                <label for="profile-address-input">Address</label>
                                <textarea id="profile-address-input" name="value" rows="3" maxlength="500" autocomplete="street-address" required><%= htmlEscape(address) %></textarea>
                                <div class="profile-edit-actions">
                                    <a class="profile-cancel-link" href="<%= contextPath %>/profile">Cancel</a>
                                    <button class="profile-save-btn" type="submit">Save Changes</button>
                                </div>
                            </form>
                        <% } else { %>
                            <div class="profile-field-content">
                                <span class="profile-field-label">Address</span>
                                <strong class="profile-field-value profile-address-value"><%= address.trim().isEmpty() ? "Not added" : htmlEscape(address) %></strong>
                            </div>
                            <a class="profile-edit-link" href="<%= contextPath %>/profile?edit=address">Edit</a>
                        <% } %>
                    </div>
                </div>
            </section>

            <aside class="profile-stats-card" aria-labelledby="quick-stats-title">
                <div class="profile-stats-heading">
                    <span class="profile-stats-icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24"><path d="M12 3 4 7v5c0 5 3.4 8 8 9 4.6-1 8-4 8-9V7z"></path><path d="m8.5 12 2.2 2.2 4.8-5"></path></svg>
                    </span>
                    <div>
                        <p class="profile-section-eyebrow">AT A GLANCE</p>
                        <h2 id="quick-stats-title">Quick Stats</h2>
                    </div>
                </div>

                <div class="profile-stat-row">
                    <span class="profile-stat-icon" aria-hidden="true">▤</span>
                    <div class="profile-stat-copy">
                        <span>Total Orders</span>
                        <strong><%= totalOrderCount < 0 ? "—" : String.valueOf(totalOrderCount) %></strong>
                    </div>
                    <a class="profile-stat-action" href="<%= contextPath %>/orders" aria-label="View order history">↗</a>
                </div>

                <div class="profile-stat-row">
                    <span class="profile-stat-icon" aria-hidden="true">♡</span>
                    <div class="profile-stat-copy">
                        <span>Favourite Restaurants</span>
                        <strong>0</strong>
                    </div>
                </div>

                <div class="profile-stat-row">
                    <span class="profile-stat-icon" aria-hidden="true">⌂</span>
                    <div class="profile-stat-copy">
                        <span>Saved Addresses</span>
                        <strong><%= address.trim().isEmpty() ? "0" : "1" %></strong>
                    </div>
                </div>

					<div class="profile-stat-row profile-created-date-row">
						<span class="profile-stat-icon" aria-hidden="true">✦</span>
						<div class="profile-stat-copy">
							<span>Account Created on</span> <strong
								class="profile-created-by-value"> <%=htmlEscape(createdDateDisplay)%>
							</strong>
						</div>
					</div>

					<a class="profile-orders-link" href="<%= contextPath %>/orders">View Order History <span aria-hidden="true">→</span></a>
                <div class="profile-stats-footnote"><span aria-hidden="true">♥</span> Good food. Happy moments.</div>
            </aside>
        </div>
    </section>
</main>

<!-- Shared BiteBloom footer: common.css owns footer styling. -->
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
