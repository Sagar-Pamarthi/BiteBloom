<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="java.util.Collection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cart</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/cart.css">
</head>
<body>

<%
    Cart cart = (Cart) session.getAttribute("cart");
    String continueUrl = request.getContextPath() + "/restaurant";

    if (cart != null && cart.getRestaurantId() != 0) {
        continueUrl = request.getContextPath() + "/menu?restaurantId=" + cart.getRestaurantId();
    }
%>

<div class="container">
    <div class="top-bar">
        <div class="title">My Cart</div>
        <a class="back-link" href="<%=continueUrl%>">← Add More Items</a>
    </div>

    <%
        if (cart == null || cart.isEmpty()) {
    %>
        <div class="empty-state">
            <h2>Your cart is empty</h2>
            <p>Add your favorite menu items to see them here.</p>
            <a class="shop-link" href="<%=request.getContextPath()%>/restaurant">Browse Restaurants</a>
        </div>
    <%
        } else {
            Collection<CartItem> items = cart.getCartItems();
    %>

        <div class="cart-box">
            <%
                for (CartItem item : items) {
                    Menu menu = item.getMenu();
                    String imagePath = request.getContextPath() + "/images/menu-default.jpg";
            %>
                <div class="cart-item">
                    <div class="item-left">
                        <img class="item-image" src="<%=imagePath%>" alt="Menu Item">

                        <div class="item-info">
                            <div class="item-name"><%= menu.getItemName() %></div>
                            <div class="item-price">Price: ₹<%= menu.getPrice() %></div>
                            <div class="item-subtotal">Subtotal: ₹<%= item.getSubTotal() %></div>
                        </div>
                    </div>

                    <div class="item-right">
                        <div class="qty-wrap-right">
                            <form action="<%=request.getContextPath()%>/cart" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="decrease">
                                <input type="hidden" name="menuId" value="<%=menu.getMenu_id()%>">
                                <input type="hidden" name="source" value="cart">
                                <button type="submit" class="qty-btn minus-btn">-</button>
                            </form>

                            <div class="qty-value"><%= item.getQuantity()%></div>

                            <form action="<%=request.getContextPath()%>/cart" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="increase">
                                <input type="hidden" name="menuId" value="<%=menu.getMenu_id()%>">
                                <input type="hidden" name="source" value="cart">
                                <button type="submit" class="qty-btn plus-btn">+</button>
                            </form>
                        </div>

					<form action="<%=request.getContextPath()%>/cart" method="post"
						style="display: inline;">
						<input type="hidden" name="action" value="remove"> <input
							type="hidden" name="menuId" value="<%=menu.getMenu_id()%>">
							<input type="hidden" name="source" value="cart">
						<button type="submit" class="remove-btn">Remove</button>
					</form>
				</div>
                </div>
            <%
                }
            %>
        </div>

        <div class="summary">
            <div class="summary-row">
                <span>Total Items</span>
                <span><%= cart.getTotalItems() %></span>
            </div>

            <div class="summary-row grand-total">
                <span>Grand Total</span>
                <span>₹<%= cart.getGrandTotal() %></span>
            </div>

            <a class="checkout-btn" href="<%=request.getContextPath()%>/checkout">Proceed to Checkout</a>

			<form action="<%=request.getContextPath()%>/cart" method="post"
				style="display: inline;">
				<input type="hidden" name="action" value="clear">
				<input type="hidden" name="source" value="cart">
				<button type="submit" class="clear-btn">Clear Cart</button>
			</form>

		</div>

	<%
        }
    %>
</div>

</body>
</html>