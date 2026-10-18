<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Order Placed Successfully</title>


<link rel="preconnect"
      href="https://fonts.googleapis.com">


<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
      rel="stylesheet">


<style>


* {

    margin: 0;

    padding: 0;

    box-sizing: border-box;

    font-family: 'Poppins', sans-serif;

}



body {

    min-height: 100vh;

    display: flex;

    justify-content: center;

    align-items: center;

    background: linear-gradient(
        135deg,
        #FFF8F2,
        #FFE8D6,
        #FFF4EC
    );

    overflow: hidden;

}



/* Background Floating Circles */


.circle {

    position: absolute;

    border-radius: 50%;

    opacity: .18;

    animation: float 8s ease-in-out infinite;

}



.circle1 {

    width: 180px;

    height: 180px;

    background: #FF7A00;

    top: -50px;

    left: -50px;

}



.circle2 {

    width: 140px;

    height: 140px;

    background: #FFB347;

    bottom: -30px;

    right: -30px;

    animation-delay: 2s;

}



.circle3 {

    width: 90px;

    height: 90px;

    background: #FF9800;

    top: 15%;

    right: 10%;

    animation-delay: 4s;

}



@keyframes float {


    0%,100% {

        transform: translateY(0);

    }


    50% {

        transform: translateY(-15px);

    }

}



/* Success Card */


.success-card {

    width: 430px;

    max-width: 88%;


    background: white;


    border-radius: 20px;


    padding: 35px 30px;


    text-align: center;


    position: relative;


    box-shadow:
        0 12px 30px rgba(0,0,0,.10);


    animation: cardShow .8s ease;

}



@keyframes cardShow {


    from {

        opacity: 0;

        transform:
            translateY(40px)
            scale(.9);

    }


    to {

        opacity: 1;

        transform:
            translateY(0)
            scale(1);

    }

}




/* Success Check Animation */


.check-container {

    width: 90px;

    height: 90px;


    margin: auto;

    margin-bottom: 18px;


    border-radius: 50%;


    background: #E8F8EC;


    display: flex;

    justify-content: center;

    align-items: center;


    animation: pop .8s ease;

}



@keyframes pop {


    0% {

        transform: scale(0);

    }


    70% {

        transform: scale(1.1);

    }


    100% {

        transform: scale(1);

    }

}



.checkmark {

    width: 42px;

    height: 22px;


    border-left:
        6px solid #2E7D32;


    border-bottom:
        6px solid #2E7D32;


    transform: rotate(-45deg);


    animation:
        tick .7s .5s forwards;


    opacity: 0;

}



@keyframes tick {


    from {

        width: 0;

        height: 0;

        opacity: 0;

    }


    to {

        width: 42px;

        height: 22px;

        opacity: 1;

    }

}





/* Text */


h1 {

    color: #3E2723;

    margin-bottom: 12px;

    font-size: 28px;

    font-weight: 600;

}



p {

    color: #777;

    line-height: 1.6;

    font-size: 15px;

    margin-bottom: 22px;

}



/* Food Icons */


.food {

    font-size: 32px;

    margin: 10px 0 25px;

    animation: bounce 2s infinite;

}



@keyframes bounce {


    0%,100% {

        transform: translateY(0);

    }


    50% {

        transform: translateY(-8px);

    }

}




/* Buttons */


.buttons {

    display: flex;

    justify-content: center;

    gap: 12px;

    flex-wrap: wrap;

}



.btn {

    padding: 12px 22px;

    border-radius: 30px;

    text-decoration: none;

    font-size: 15px;

    font-weight: 600;

    transition: .3s;

}




.primary {

    background: #FF7A00;

    color: white;

}



.primary:hover {

    background: #F26C00;

    transform: translateY(-3px);

    box-shadow:
        0 8px 15px rgba(255,122,0,.3);

}



.secondary {

    border: 2px solid #FF7A00;

    color: #FF7A00;

    background: white;

}



.secondary:hover {

    background: #FFF3EA;

    transform: translateY(-3px);

}




/* Confetti */


.confetti {

    position: absolute;

    width: 8px;

    height: 15px;

    top: -30px;

    animation:
        fall 4s linear infinite;

}



@keyframes fall {


    0% {

        transform:
            translateY(-100px)
            rotate(0deg);

        opacity: 1;

    }


    100% {

        transform:
            translateY(900px)
            rotate(720deg);

        opacity: 0;

    }

}




/* Mobile Responsive */


@media(max-width:600px) {


    .success-card {

        width: 95%;

        padding: 28px 20px;

    }



    h1 {

        font-size: 24px;

    }



    .food {

        font-size: 28px;

    }



    .buttons {

        flex-direction: column;

    }



    .btn {

        width: 100%;

    }

}



</style>


</head>



<body>


<!-- Background Circles -->


<div class="circle circle1"></div>

<div class="circle circle2"></div>

<div class="circle circle3"></div>




<!-- Confetti Animation -->


	<%
	String[] colors = {

	    "#FF7A00",
	    "#4CAF50",
	    "#FFB347",
	    "#FF5252",
	    "#2196F3",
	    "#FFD54F"

	};

	for (int i = 0; i < 20; i++) {
	%>


	<div class="confetti"
		style="

		left:<%=(int) (Math.random() * 100)%>%;
		
		background:<%=colors[(int) (Math.random() * colors.length)]%>;
		
		animation-delay:<%=Math.random() * 3%>s;
		
		animation-duration:<%=3 + Math.random() * 2%>s;
		
		">

	</div>


	<%
	}
	%>





	<!-- Success Card -->


<div class="success-card">



    <!-- Animated Check -->


    <div class="check-container">

        <div class="checkmark"></div>

    </div>





    <h1>

        Order Placed Successfully!

    </h1>





    <p>

        Thank you for ordering with us.

        <br>

        Your delicious meal is now being prepared.

        <br><br>

        You can check your order status anytime from

        <strong>My Orders</strong>.

    </p>






    <!-- Food Animation -->


    <div class="food">

        🍔 &nbsp; 🍕 &nbsp; 🍟 &nbsp; 🥤

    </div>







    <!-- Buttons -->


    <div class="buttons">



        <a href="<%=request.getContextPath()%>/OrdersController"

           class="btn primary">

            My Orders

        </a>




        <a href="<%=request.getContextPath()%>/RestaurantServlet"

           class="btn secondary">

            Continue Shopping

        </a>



    </div>



</div>



</body>

</html>