<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<%@ page import="java.util.*"%>
<%@ page import="com.tap.model.Orders"%>
<%@ page import="com.tap.model.Order_item"%>
<%@ page import="com.tap.model.Restaurant"%>
<%@ page import="com.tap.model.Menu"%>



<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>My Orders</title>


<style>
* {
	box-sizing: border-box;
}

body {
	margin: 0;
	font-family: 'Poppins', Arial, sans-serif;
	background: #fff8f2;
	color: #4e342e;
}

/* Navbar */
.navbar {
	background: linear-gradient(90deg, #ff7a00, #ff9800);
	color: white;
	padding: 20px 50px;
	font-size: 25px;
	font-weight: bold;
}

/* Container */
.container {
	width: 85%;
	margin: 35px auto;
}

.heading {
	font-size: 32px;
	margin-bottom: 25px;
}

/* Order Card */
.order-card {
	background: white;
	border-radius: 20px;
	padding: 25px;
	margin-bottom: 25px;
	box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
}

/* Header */
.order-header {
	display: flex;
	justify-content: space-between;
	color: #777;
	font-size: 14px;
	margin-bottom: 20px;
}

/* Restaurant */
.restaurant-section {
	display: flex;
	gap: 20px;
	align-items: center;
}

.restaurant-img {
	width: 100px;
	height: 100px;
	border-radius: 18px;
	object-fit: cover;
}

.restaurant-name {
	font-size: 23px;
	font-weight: bold;
}

.address {
	margin-top: 6px;
	color: #777;
	font-size: 14px;
}

/* Status */
.status {
	display: inline-block;
	margin-top: 12px;
	padding: 7px 16px;
	border-radius: 20px;
	font-size: 14px;
	font-weight: bold;
}

.delivered {
	background: #e8f5e9;
	color: #2e7d32;
}

.preparing {
	background: #fff3e0;
	color: #ef6c00;
}

.ontheway {
	background: #e3f2fd;
	color: #1565c0;
}

.cancelled {
	background: #ffebee;
	color: #c62828;
}

.placed {
	background: #f3e5f5;
	color: #6a1b9a;
}

/* Items */
.items-section {
	margin-top: 25px;
	border-top: 1px solid #eee;
	padding-top: 15px;
}

.item-row {
	display: flex;
	justify-content: space-between;
	padding: 10px 0;
	font-size: 16px;
}

/* Bottom */
.bottom-section {
	margin-top: 20px;
	border-top: 1px solid #eee;
	padding-top: 15px;
	font-size: 17px;
}

.payment {
	margin-top: 8px;
}

/* Button */
.actions {
	margin-top: 20px;
}

.order-again {
	text-decoration: none;
	background: #ff7a00;
	color: white;
	padding: 11px 25px;
	border-radius: 25px;
	font-weight: bold;
}

/* Empty */
.empty {
	text-align: center;
	margin-top: 100px;
	font-size: 25px;
}

/* Mobile */
@media ( max-width :700px) {
	.container {
		width: 92%;
	}
	.navbar {
		padding: 18px;
	}
	.order-header {
		flex-direction: column;
		gap: 8px;
	}
	.restaurant-section {
		flex-direction: column;
		align-items: flex-start;
	}
	.restaurant-img {
		width: 120px;
		height: 120px;
	}
	.item-row {
		font-size: 14px;
	}
}
</style>


</head>



<body>



	<div class="navbar">🍴 Food Delivery App</div>



	<div class="container">



		<h1 class="heading">My Orders</h1>



		<%
		List<Orders> orders = (List<Orders>) request.getAttribute("orders");

		Map<Integer, List<Order_item>> orderItemsMap = (Map<Integer, List<Order_item>>) request.getAttribute("orderItemsMap");

		Map<Integer, Restaurant> restaurantMap = (Map<Integer, Restaurant>) request.getAttribute("restaurantMap");

		Map<Integer, Menu> menuMap = (Map<Integer, Menu>) request.getAttribute("menuMap");

		if (orders == null || orders.isEmpty()) {
		%>


		<div class="empty">


			📦 No orders yet <br> Start ordering your favourite food!


		</div>



		<%
		}

		else {

		for (Orders order : orders) {

			Restaurant restaurant = restaurantMap.get(order.getRestaurant_id());

			List<Order_item> items = orderItemsMap.get(order.getOrder_id());

			String status = order.getStatus();

			String statusClass = "placed";

			if (status.equalsIgnoreCase("delivered")) {

				statusClass = "delivered";

			}

			else if (status.equalsIgnoreCase("preparing")) {

				statusClass = "preparing";

			}

			else if (status.equalsIgnoreCase("on the way")) {

				statusClass = "ontheway";

			}

			else if (status.equalsIgnoreCase("cancelled")) {

				statusClass = "cancelled";

			}
		%>




		<div class="order-card">



			<div class="order-header">


				<div>

					Order ID : #<%=order.getOrder_id()%>

				</div>


				<div>

					<%=order.getOrder_date()%>

				</div>


			</div>





			<div class="restaurant-section">



				<%
				String image = restaurant.getImagepath();

				if (image == null || image.isEmpty()) {

					image = "images/default-restaurant.jpg";

				}
				%>




				<img class="restaurant-img"
					src="<%=request.getContextPath()%>/<%=image%>">



				<div>



					<div class="restaurant-name">


						<%=restaurant.getName()%>


					</div>



					<div class="address">

						📍
						<%=restaurant.getAddress()%>

					</div>



					<div class="address">

						🚴 Delivery in
						<%=restaurant.getDelivery_time()%>
						mins

					</div>




					<div class="status <%=statusClass%>">


						<%=status%>


					</div>



				</div>


			</div>







			<div class="items-section">


				<h3>Items</h3>



				<%
				for (Order_item item : items) {

					Menu menu = menuMap.get(item.getMenu_id());
				%>




				<div class="item-row">


					<div>


						<%=menu.getItemName()%>


						&nbsp; × &nbsp;


						<%=item.getQuantity()%>


					</div>



					<div>


						₹
						<%=item.getItem_total()%>


					</div>


				</div>



				<%
				}
				%>



			</div>







			<div class="bottom-section">


				<b> Total Amount : </b> ₹
				<%=order.getTotal_amount()%>



				<div class="payment">


					<b> Payment : </b>


					<%=order.getPayment_mode()%>


				</div>



			</div>




			<div class="actions">


				<a class="order-again"
					href="<%=request.getContextPath()%>/restaurant?id=<%=restaurant.getRestaurant_id()%>">


					Order Again </a>


			</div>




		</div>





		<%
		}

		}
		%>



	</div>


</body>


</html>