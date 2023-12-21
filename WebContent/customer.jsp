<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
	<style>
        body {
            font-family: Georgia, serif !important;
			margin: 20px !important; /* Use !important to increase specificity */
        }

        table {
            width: 60% !important;
            border-collapse: collapse;
            background-color: #F2F2F2; /* Set your desired background color */
            margin-top: 20px; /* Optional: Add some space above the table */
        }

        th, td {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }

        th {
            background-color: #7FBFB0; /* Set your desired header background color */
            color: white;
        }

		.hd-h1 {
			font-family: Georgia, serif !important;
			padding-top: 20px !important;
			padding-left: 10px !important;
		}
    </style>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<%
	userName = (String) session.getAttribute("authenticatedUser");
%>

<%
// TODO: Print Customer information
if (userName == null) {
	out.println("<h1>Please Login to System: <a href=login.jsp>Login</a> </h1>");
} else {
	getConnection();
	String sql = "SELECT * FROM customer WHERE userid = ?";
	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setString(1, userName);
	ResultSet rst = pstmt.executeQuery();
	
	int customerId = 0;
	String firstName = "";
	String lastName = "";
	String email = "";
	String phone = "";
	String address = "";
	String city = "";
	String state = "";
	String postalCode = "";
	String country = "";
	String userid = "";
	
	if (rst.next()) {
		customerId = rst.getInt(1);
		firstName = rst.getString(2);
		lastName = rst.getString(3);
		email = rst.getString(4);
		phone = rst.getString(5);
		address = rst.getString(6);
		city = rst.getString(7);
		state = rst.getString(8);
		postalCode = rst.getString(9);
		country = rst.getString(10);
		userid = rst.getString(11);
	}
	
	out.println("<h1 class=hd-h1>Customer Profile</h1>");
	out.println("<table class=table border=1><tr><th>Id</th><td>" + customerId + "</td></tr>");
	out.println("<tr><th>First Name</th><td>" + firstName + "</td></tr>");
	out.println("<tr><th>Last Name</th><td>" + lastName + "</td></tr>");
	out.println("<tr><th>Email</th><td>" + email + "</td></tr>");
	out.println("<tr><th>Phone</th><td>" + phone + "</td></tr>");
	out.println("<tr><th>Address</th><td>" + address + "</td></tr>");
	out.println("<tr><th>City</th><td>" + city + "</td></tr>");
	out.println("<tr><th>State</th><td>" + state + "</td></tr>");
	out.println("<tr><th>Postal Code</th><td>" + postalCode + "</td></tr>");
	out.println("<tr><th>Country</th><td>" + country + "</td></tr>");
	out.println("<tr><th>User id</th><td>" + userid + "</td></tr></table>");
	
	// Make sure to close connection
	closeConnection();
}
%>

</body>
</html>

