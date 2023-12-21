<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.sql.Timestamp, java.time.LocalDateTime" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Sakura Ka Tei Order List</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
	<style>
        body {
        	font-family: Georgia, serif !important;
			margin: 20px !important;
        }

        table {
            width: 100%;
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

<%@ include file="header.jsp" %>

<!-- Taii Hirano, 44551257 -->
<!-- Yuki Isomura, 11888757 -->

<%-- <h1 align=center><font face=cursive color=#3399FF>Taii's Nandemo Grocery</font></h1> --%>
<%-- <h1 class=hd-h1>Order List</h1> --%>

<%
	userName = (String) session.getAttribute("authenticatedUser");
%>

<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);  // Prints $5.00

// Make connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

// Write query to retrieve all order summary records
try ( Connection con = DriverManager.getConnection(url, uid, pw);
		Statement stmt = con.createStatement();) 
{
	out.println("<table class=table border=1><tr><th>Order Id</th><th>Order Date</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th></tr>");
	
	String sql = null;
	PreparedStatement pstmt = null;
	ResultSet rst = null;

	if(userName != null){ // if any user logged in 
		// Write title
		out.print("<h1 class=hd-h1>Your Order List</h1>");
		// Retrieve customerId 
		sql = "SELECT customerId FROM customer WHERE userid = ?";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, userName);
		rst = pstmt.executeQuery();
		int customerId = -1;
		if (rst.next()) {
			customerId = rst.getInt(1);
		}
		// Get the list of order for the user who is logged in
		sql = "SELECT orderId, orderDate, ordersummary.customerId, firstName, lastName, totalAmount " +
			  "FROM ordersummary LEFT JOIN customer ON ordersummary.customerId = customer.customerId " + 
			  "WHERE ordersummary.customerId = ?";
		pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, customerId);
		

	} else {
		// Write title
		out.print("<h1 class=hd-h1>Order List of All Customers</h1>");
		// Get the list of order for all customers
		sql = "SELECT orderId, orderDate, ordersummary.customerId, firstName, lastName, totalAmount " +
			  "FROM ordersummary LEFT JOIN customer ON ordersummary.customerId = customer.customerId ";
		pstmt = con.prepareStatement(sql);	  
	}

	rst = pstmt.executeQuery();

	// ResultSet rst = stmt.executeQuery(
	// 	"SELECT orderId, orderDate, ordersummary.customerId, firstName, lastName, totalAmount " +
	// 	"FROM ordersummary LEFT JOIN customer ON ordersummary.customerId = customer.customerId ");
	

	while (rst.next()) {
		int orderId = rst.getInt(1);
		java.sql.Timestamp timestamp = rst.getTimestamp(2);
		String orderDate = timestamp.toString();
		int customerId = rst.getInt(3);
		String firstName = rst.getString(4);
		String lastName = rst.getString(5);
		double totalAmount = rst.getDouble(6);

		out.println("<tr><td>" + orderId + "</td><td>" + orderDate + "</td><td>" + customerId + "</td><td>" + firstName + " " + lastName + "</td>");
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		out.println("<td>" + currFormat.format(totalAmount) + "</td></tr>");	// Prints $5.00
		// Note: Using a PreparedStatement here would be even better!
		sql = "SELECT productId, quantity, price " +
					 "FROM orderproduct JOIN ordersummary ON orderproduct.orderId = ordersummary.orderId " +
					 "WHERE  orderproduct.orderId = ? ";
		PreparedStatement stmt2 = con.prepareStatement(sql);
		stmt2.setInt(1, orderId);
		ResultSet rst2 = stmt2.executeQuery();

		out.println("<tr align=right><td colspan=4><table class=table border=1>");
		out.println("<th>Product Id</th><th>Quantity</th><th>Price</th></tr>");

		int totalItem = 0;
		while (rst2.next()) {
			int productId = rst2.getInt(1);
			int quantity = rst2.getInt(2);
			double price = rst2.getDouble(3);
			out.println("<tr><td>" + productId + "</td><td>" + quantity + "</td>");
			NumberFormat currFmt = NumberFormat.getCurrencyInstance();
			out.println("<td>" + currFmt.format(price) + "</td></tr>");
			totalItem += quantity;
		}
		out.println("<tr><th>Total</th><td>"+ totalItem + "</td><td>" + currFormat.format(totalAmount) + "</td></tr>");
		out.println("</table>");

	}
	out.print("</table>");
	out.close();

	// Close connection
	con.close();
} catch (SQLException ex) {
	out.println("SQLException: " + ex);
}	
	
%>

</body>
</html>

