<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Sakura Ka Tei Order Processing</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
	<style>
        body {
            font-family: Georgia, serif !important;
			margin: 20px !important; /* Use !important to increase specificity */
        }

        table {
			font-family: Georgia, serif !important;
			font-size: 20px !important;
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

		.form-fm, .hd-h1, .hd-h3 {
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

<% 
// Get customer id and password entered by user
String custId = request.getParameter("customerId");
String password = request.getParameter("password");
String paymentType = request.getParameter("paymenttype");
String paymentNum = request.getParameter("paymentnumber");
String paymentExpDate = request.getParameter("paymentexpirydate");

@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Determine if there are products in the shopping cart
// If either are not true, display an error message

// Make connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try ( Connection con = DriverManager.getConnection(url, uid, pw);
        Statement stmt = con.createStatement();) 
{
	// Determine if valid customer id was entered
    // Input check
    boolean hasCustId = custId != null && !custId.equals("");

    // Take list of ids and check validity
    String sql = "SELECT customerId FROM customer";
    PreparedStatement pstmt = con.prepareStatement(sql);
    ResultSet rst = pstmt.executeQuery();
    boolean validId = false;
	int customerId = 0;
	boolean numId = true;

	try {
		customerId = Integer.parseInt(custId);
	} catch (NumberFormatException e) {
		numId = false;
	}

    while (numId && rst.next()) {
        if (customerId == rst.getInt(1)){
            validId = true; 
            break;
        }
    }

	// Check the password
	String sql5 = "SELECT password FROM customer WHERE customerId = ?";
	PreparedStatement pstmt5 = con.prepareStatement(sql5);
	pstmt5.setInt(1, customerId); //customerId
	ResultSet rst5 = pstmt5.executeQuery();
	boolean validPW = false;
	String actualPassword = "";
	while(rst5.next()){
		actualPassword = rst5.getString(1);
	}
	if(password.equals(actualPassword)){
		validPW = true;
	}

	// Check the payment number
	long paymentNumber = 0;
	boolean validPayNum = true;
	try {
		if (paymentNum.length() != 16)
			validPayNum = false;
		else
			paymentNumber = Long.parseLong(paymentNum);
	} catch (NumberFormatException e) {
		out.println("error");
		validPayNum = false;
	}

	// Check the payment expiry date
	boolean validPayExp = true;
	int paymentExpiryDate = 0;
	try {
		if (paymentExpDate.length() != 4)
			validPayExp = false;
		else {
			paymentExpiryDate = Integer.parseInt(paymentExpDate);
			int month = paymentExpiryDate % 100;
			if (month < 1 || month > 12)
				validPayExp = false;
		}
	} catch (NumberFormatException e) {
		validPayExp = false;
		out.println("3");
	}

	if (!validId){
		out.println("<h1 class=hd-h1>Invalid customer id. Go back to the previous page and try again.</h1>");
		out.println("<h3 class=hd-h3><a href=checkout.jsp>Go Back</a></h3>");
	} else if (!validPW){
		out.println("<h1 class=hd-h1>The password you entered was not correct. Please go back and try again.</h1>");
		out.println("<h3 class=hd-h3><a href=checkout.jsp>Go Back</a></h3>");
	} else if (!validPayNum) {
		out.println("<h1 class=hd-h1>Invalid payment number. Please provide a 16-digit card number.</h1>");
		out.println("<h3 class=hd-h3><a href=checkout.jsp>Go Back</a></h3>");
	} else if (!validPayExp) {
		out.println("<h1 class=hd-h1>Invalid payment expiry date. Please provide a expiry date in the form of YYMM.</h1>");
		out.println("<h3 class=hd-h3><a href=checkout.jsp>Go Back</a></h3>");
	} else {
		if (productList == null || productList.size() < 1) {
			out.println("<h1 class=hd-h1>Your shopping cart is empty!</h1>");
			out.println("<h2 class=hd-h2><a href=index.jsp>Back to Main Page</a></h2>");
			productList = new HashMap<String, ArrayList<Object>>();
		} else {
			// Get customer information based on customer id
			String sql2 = "SELECT firstName, lastName, address, city, state, postalCode, country " + 
						  "FROM customer " + 
						  "WHERE customerId = ?";
			PreparedStatement pstmt2 = con.prepareStatement(sql2);
			pstmt2.setInt(1, customerId);
			ResultSet rst2 = pstmt2.executeQuery();
			rst2.next();
			String firstName = rst2.getString(1);
			String lastName = rst2.getString(2);
			String address = rst2.getString(3);
			String city = rst2.getString(4);
			String state = rst2.getString(5);
			String postalCode = rst2.getString(6);
			String country = rst2.getString(7);

			// Get the current time 
			Timestamp timestamp = new Timestamp(System.currentTimeMillis());  
			String orderDate = timestamp.toString();

			// Here is the code to traverse through a HashMap
			// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price
			// Insert each item into OrderProduct table using OrderId from previous INSERT
			
			// Calculate total price 
			double totalAmount = 0; 
			Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
			while (iterator.hasNext())
			{ 
				Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				String productId = (String) product.get(0);
				String price = (String) product.get(2);
				double pr = Double.parseDouble(price);
				int qty = ( (Integer)product.get(3)).intValue();
				// calculate subtotal and add to total
				double subtotal = pr * qty;
				totalAmount += subtotal;
			}

			// Save order information to database
			// Update total amount for order record
			// Insert new order into OrderSummary
			String sql3 = "INSERT INTO ordersummary (orderDate, totalAmount, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry, customerId) " +
							"VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

			/*
			// Use retrieval of auto-generated keys.
			PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
			ResultSet keys = pstmt.getGeneratedKeys();
			keys.next();
			int orderId = keys.getInt(1);
			*/
			PreparedStatement pstmt3 = con.prepareStatement(sql3, Statement.RETURN_GENERATED_KEYS);	
			pstmt3.setString(1, orderDate);
			pstmt3.setDouble(2, totalAmount);
			pstmt3.setString(3, address);
			pstmt3.setString(4, city);
			pstmt3.setString(5, state);
			pstmt3.setString(6, postalCode);
			pstmt3.setString(7, country);
			pstmt3.setInt(8, customerId);
			pstmt3.executeUpdate();
			ResultSet keys = pstmt3.getGeneratedKeys();
			keys.next();
			int orderId = keys.getInt(1);
			keys.close();

			// Insert product information into orderproduct
			Iterator<Map.Entry<String, ArrayList<Object>>> iterator2 = productList.entrySet().iterator();
			while (iterator2.hasNext())
			{ 
				Map.Entry<String, ArrayList<Object>> entry = iterator2.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				String productId = (String) product.get(0);
				String price = (String) product.get(2);
				double pr = Double.parseDouble(price);
				int qty = ( (Integer)product.get(3)).intValue();

				String sql4 = "INSERT INTO orderproduct (orderId, productId, quantity, price) " +
								"VALUES (?, ?, ?, ?)";
				PreparedStatement pstmt4 = con.prepareStatement(sql4, Statement.RETURN_GENERATED_KEYS);	
				pstmt4.setInt(1, orderId);
				pstmt4.setString(2, productId);
				pstmt4.setInt(3, qty);
				pstmt4.setDouble(4, pr);
				pstmt4.executeUpdate();
			}

			// Print out the order summary
			out.println("<h1 class=hd-h1>Your Order Summary</h1>");
			out.print("<table class=table border=1><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");
			NumberFormat currFormat = NumberFormat.getCurrencyInstance();

			// Show table
			Iterator<Map.Entry<String, ArrayList<Object>>> iterator3 = productList.entrySet().iterator();
			double total =0; 
			while (iterator3.hasNext())
			{ 
				Map.Entry<String, ArrayList<Object>> entry = iterator3.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				String productId = (String) product.get(0);
				String productName = (String) product.get(1);
				String price = (String) product.get(2);
				double pr = Double.parseDouble(price);
				int qty = ( (Integer)product.get(3)).intValue();
				double subtotal = pr * qty;
				total += subtotal;

				out.print("<tr><td>" + productId + "</td>");
				out.print("<td>" + productName + "</td>"); 
				out.print("<td align=center>" + qty + "</td>"); 
				out.print("<td align=right>" + currFormat.format(pr) + "</td>");
				out.print("<td align=right>" + currFormat.format(subtotal) + "</td></tr>"); 
	
			}
			out.print("<tr><td colspan=4 align=right><b>Order Total</b></td>"); 
			out.println("<td align=right>"+currFormat.format(total)+"</td></tr>"); 
			out.println("</table>");

			out.println("<h1 class=hd-h1>Order completed. Will be delivered soon...<a href=ship.jsp?orderId=" + orderId + ">Check Delivery Status</a></h1>");
			out.println("<h1 class=hd-h1>Your order reference number is: " + orderId + "</h1>"); 
			out.println("<h1 class=hd-h1>Delivering to customer: " + customerId + "</h1>"); 
			out.println("<h1 class=hd-h1>Name: " + firstName + " " + lastName + "</h1>"); 
			
			// Clear cart if order placed successfully
			productList.clear();
		}	
	}
	out.close();
	// Close connection
	con.close();
} catch (SQLException ex) {
	out.println("SQLException: " + ex);
}
%>
</body>
</html>

