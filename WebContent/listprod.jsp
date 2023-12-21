<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Sakura Ka Tei</title>
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

		.col-md-1 {
			width: 150px;
		}
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<!-- Taii Hirano, 44551257 -->
<!-- Yuki Isomura, 11888757 -->

<%-- <h1 align=center><font face=cursive color=#3399FF>Taii's Nandemo Grocery</font></h1> --%>

<h1 class=hd-h1>Browse Products By Category and Search by Product Name:</h1>

<form class=form-fm method="get" action="listprod.jsp">
  <p align="left">
  <select size="1" name="categoryName">
  <option>All</option>

  <option>Sushi</option>
  <option>Seafood</option>
  <option>Set Menu</option>
  <option>Donburi</option>
  <option>Noodle</option>
  <option>Hot Pot</option>
  <option>Skewer</option>

  <input type="text" name="productName" size="50">
  </select><input type="submit" value="Submit"><input type="reset" value="Reset"></p> (Leave blank for all products)
</form>

<h3 class=hd-h3>All Products</h3>

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

// Make the connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try ( Connection con = DriverManager.getConnection(url, uid, pw);) 
{
	// Write query to retrieve all order summary records
	// String sql = "SELECT productId, productName, productPrice, categoryId, productImageURL FROM product";
	String sql = "SELECT product.productId, productName, productPrice, categoryId, productImageURL, SUM(quantity) AS totalOrderedQuantity " +
				 "FROM product LEFT JOIN orderproduct ON product.productId = orderproduct.productId " +
				 "GROUP BY product.productId, productName, productPrice, categoryId, productImageURL "+
				 "ORDER BY totalOrderedQuantity DESC, product.productId ASC";
			
	PreparedStatement pstmt = null;
	ResultSet rst = null;
	// Get product category to search for
	String categoryName = request.getParameter("categoryName");
	if (categoryName == null)
		categoryName = "All";
	int catId = 0;
	if (categoryName.equals("Sushi"))
		catId = 1;
	else if (categoryName.equals("Seafood"))
		catId = 2;
	else if (categoryName.equals("Set Menu"))
		catId = 3;
	else if (categoryName.equals("Donburi"))
		catId = 4;
	else if (categoryName.equals("Noodle"))
		catId = 5;
	else if (categoryName.equals("Hot Pot"))
		catId = 6;
	else if (categoryName.equals("Skewer"))
		catId = 7;

	// Create a Hash Map for each Category and Category font color
	HashMap<Integer, String> category = new HashMap<>();
	category.put(1, "Sushi");
	category.put(2, "Seafood");
	category.put(3, "Set Menu");
	category.put(4, "Donburi");
	category.put(5, "Noodle");
	category.put(6, "Hot Pot");
	category.put(7, "Skewer");
	HashMap<Integer, String> catColor = new HashMap<>();
	catColor.put(1, "#2E96FF");
	catColor.put(2, "#FD632E");
	catColor.put(3, "#1166A7");
	catColor.put(4, "#A959FF");
	catColor.put(5, "#D03D23");
	catColor.put(6, "#45A12C");
	catColor.put(7, "#6C4E49");
	// catColor.put(8, "#55A5B3");

	// Get product name to search for
	String name = request.getParameter("productName");

	boolean hasCatgry = catId != 0;
	boolean hasSearch = name != null && !name.equals("");

	// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!
	// PreparedStatement pstmt = null;
	// ResultSet rst = null;
	if (!hasCatgry && !hasSearch) {		// All and blank
		pstmt = con.prepareStatement(sql);
	} else if (hasCatgry && !hasSearch) {	// Category and blank
		sql = "SELECT product.productId, productName, productPrice, categoryId, productImageURL, SUM(quantity) AS totalOrderedQuantity " +
			  "FROM product LEFT JOIN orderproduct ON product.productId = orderproduct.productId " +
			  "WHERE categoryId = ? " +
			  "GROUP BY product.productId, productName, productPrice, categoryId, productImageURL " +
			  "ORDER BY totalOrderedQuantity DESC, product.productId ASC";
		pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, catId);
	} else if (!hasCatgry && hasSearch) {	// All and search
		sql = "SELECT product.productId, productName, productPrice, categoryId, productImageURL, SUM(quantity) AS totalOrderedQuantity " +
			  "FROM product LEFT JOIN orderproduct ON product.productId = orderproduct.productId " +
			  "WHERE productName LIKE ? " +
			  "GROUP BY product.productId, productName, productPrice, categoryId, productImageURL " +
			  "ORDER BY totalOrderedQuantity DESC, product.productId ASC";
		name = "%" + name + "%";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, name);
	} else if (hasCatgry && hasSearch) {	// Category and search
		sql = "SELECT product.productId, productName, productPrice, categoryId, productImageURL, SUM(quantity) AS totalOrderedQuantity " +
			  "FROM product LEFT JOIN orderproduct ON product.productId = orderproduct.productId " +
			  "WHERE productName LIKE ? AND categoryId = ? " +
			  "GROUP BY product.productId, productName, productPrice, categoryId, productImageURL " +
			  "ORDER BY totalOrderedQuantity DESC, product.productId ASC";
		name = "%" + name + "%";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, name);
		pstmt.setInt(2, catId);
	} 
	rst = pstmt.executeQuery();
	
	// Print out the ResultSet
	out.println("<font face=Century Gothic size=3><table class=table border=1><tr><th class=col-md-1></th><th>Product Name</th><th>Product Image</th><th>Category</th><th>Price</th></tr>");
	while (rst.next()) {
		int productId = rst.getInt(1);
		String productName = rst.getString(2);
		double productPrice = rst.getDouble(3);
		int categoryId = rst.getInt(4);
		String productImageURL = rst.getString(5);
		// For each product create a link of the form
		// out.println("<tr><td class=col-md-1><a href=addcart.jsp?id=" + productId + "&name=" + java.net.URLEncoder.encode(productName, "UTF-8") + "&price=" + productPrice + ">Add to Cart</a></td>");
		out.println("<tr><td class='col-md-1' style='text-align: center;'><form action='addcart.jsp' method='GET'>");
		out.println("<input type='hidden' name='id' value='" + productId + "'>");
		out.println("<input type='hidden' name='name' value='" + java.net.URLEncoder.encode(productName, "UTF-8") + "'>");
		out.println("<input type='hidden' name='price' value='" + productPrice + "'>");
		out.println("<button type='submit' style='background-color: #638AB4; color: #FFFFFF;'>Add to Cart</button></form></td>");
		out.println("<td class=col-6><a href=product.jsp?id=" + productId + ">" + productName + "</a></td>");
		// out.println("<td><font color=" + catColor.get(categoryId) + ">" + productName + "</font></td>");
		out.println("<td><img src=" + productImageURL + "></img></td>");
		out.println("<td><font color=" + catColor.get(categoryId) + ">" + category.get(categoryId) + "</font></td>");
		NumberFormat currFmt = NumberFormat.getCurrencyInstance();
		out.println("<td><font color=" + catColor.get(categoryId) + ">" + currFmt.format(productPrice) + "</font></td></tr>");
	}
	out.println("</table></font>");
	out.close();
	// Close connection
	con.close();
} catch (SQLException ex) {
	out.println("SQLException: " + ex);
}
// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00
%>

</body>
</html>