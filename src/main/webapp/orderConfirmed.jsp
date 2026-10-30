<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String contextPath = request.getContextPath();
    Object orderIdObject = session.getAttribute("recentOrderId");

    if (orderIdObject == null) {
        response.sendRedirect(contextPath + "/restaurants");
        return;
    }
  
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#30171f">
    <title>BiteBloom | Order Confirmed</title>
	<link rel="icon"
          type="image/png"
          href="<%= request.getContextPath() %>/images/bitebloom-favicon.png">
    <link rel="stylesheet" href="<%= contextPath %>/css/common.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/order-confirmation.css">
</head>
<body class="order-confirmation-body">

<main class="confirmation-stage">
    <!-- Brand-colour confetti stays decorative and never blocks the buttons. -->
    <div class="confirmation-confetti" aria-hidden="true">
        <span class="confetti-piece confetti-piece-1"></span>
        <span class="confetti-piece confetti-piece-2"></span>
        <span class="confetti-piece confetti-piece-3"></span>
        <span class="confetti-piece confetti-piece-4"></span>
        <span class="confetti-piece confetti-piece-5"></span>
        <span class="confetti-piece confetti-piece-6"></span>
        <span class="confetti-piece confetti-piece-7"></span>
        <span class="confetti-piece confetti-piece-8"></span>
        <span class="confetti-piece confetti-piece-9"></span>
        <span class="confetti-piece confetti-piece-10"></span>
        <span class="confetti-piece confetti-piece-11"></span>
        <span class="confetti-piece confetti-piece-12"></span>
    </div>

    <section class="confirmation-card" aria-labelledby="confirmation-title">

        <div class="confirmation-mark-wrap">
            <span class="mark-glow" aria-hidden="true"></span>
            <img class="confirmation-mark"
                 src="<%= contextPath %>/images/Check mark golden.svg"
                 alt="Order confirmed">
        </div>


        <p class="confirmation-eyebrow">MADE WITH CARE, JUST FOR YOU</p>
        <h1 id="confirmation-title">Order Placed<br><span>Successfully!</span></h1>
        <p class="confirmation-message">
            Thank you for ordering with us,
            Your order is confirmed and ready for the kitchen to get started.
        </p>

        <!-- Elegant line icons and a real status sequence. -->
        <div class="confirmation-journey" aria-label="Order journey">
            <div class="journey-item is-current">
                <span class="journey-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none" focusable="false"><rect x="5" y="3" width="14" height="18" rx="2"></rect><path d="M9 8h6M9 12h6M9 16h4"></path></svg>
                </span>
                <span class="journey-label">Order placed</span>
            </div>
            <span class="journey-line" aria-hidden="true"></span>
            <div class="journey-item">
                <span class="journey-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none" focusable="false"><path d="M3 14h18l-1.7-4.3A3 3 0 0 0 16.5 8h-9A3 3 0 0 0 4.7 9.7L3 14Z"></path><path d="M4 14v3a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-3M8 8c0-1.2.8-2 2-2M13 8c0-1.2.8-2 2-2"></path></svg>
                </span>
                <span class="journey-label">Prepared</span>
            </div>
            <span class="journey-line" aria-hidden="true"></span>
            <div class="journey-item">
                <span class="journey-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none" focusable="false"><circle cx="6" cy="17" r="2.5"></circle><circle cx="18" cy="17" r="2.5"></circle><path d="M8.5 17H14l2-6h3l2 6M14 17l-3-6H7l-2 4M11 11H8"></path></svg>
                </span>
                <span class="journey-label">On its way</span>
            </div>
        </div>
        <p class="confirmation-footnote">Your order status will update as the restaurant processes your order.</p>

        <div class="confirmation-actions">
            <a class="confirmation-primary-action" href="<%= contextPath %>/orders">My Orders <span aria-hidden="true">→</span></a>
            <a class="confirmation-secondary-action" href="<%= contextPath %>/restaurants">Continue Ordering</a>
        </div>
        <p class="confirmation-reassurance"><span aria-hidden="true">✦</span> Good food. Happy moments.</p>
    </section>
</main>

</body>
</html>
