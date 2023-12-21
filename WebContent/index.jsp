<!DOCTYPE html>
<html>
<head>
<title>Sakura Ka Tei Main Page</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
	<style>
        body {
            font-family: Georgia, serif !important;
			color: white;
			margin: 20px !important; /* Use !important to increase specificity */
			background-image: url('img/title.jpg'); /* Set the path to your background image */
			background-size: cover; /* Cover the entire background */
        }

		h2 a {
    		text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.8); /* Adjust values as needed */
		}

		.hd-h3 {
			text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.8); /* Adjust values as needed */
			font-family: Georgia, serif !important;
			color: white !important;
			padding: 10px !important;
		}
    </style>
</head>
<body>
<%-- <h1 align=center><font face=cursive color=#3399FF>Sakura Ka Tei</font></h1> --%>
<%-- <h1 align="center">Welcome to Taii's Nandemo Grocery</h1> --%>

<%@ include file="header.jsp" %>

<h2 align="center"><a href="login.jsp">Login</a></h2>

<h2 align="center"><a href="signup.jsp">Sign up</a></h2>

<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

<h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

<h2 align="center"><a href="customer.jsp">Customer Info</a></h2>

<h2 align="center"><a href="admin.jsp">Administrators</a></h2>

<h2 align="center"><a href="logout.jsp">Logout</a></h2>

<%
	userName = (String) session.getAttribute("authenticatedUser");
	if (userName != null)
		out.println("<h3 class=hd-h3 align=\"center\">Signed in as: "+userName+"</h3>");
%>

<%-- <h4 align="center"><a href="ship.jsp?orderId=1">Test Ship orderId=1</a></h4> --%>

<%-- <h4 align="center"><a href="ship.jsp?orderId=3">Test Ship orderId=3</a></h4> --%>

</body>
</head>


