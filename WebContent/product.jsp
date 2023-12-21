<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.sql.Timestamp, java.util.Date" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Sakura Ka Tei - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: Georgia, serif !important;
			margin: 20px !important; /* Use !important to increase specificity */
        }

        table {
            width: 50% !important;
            border-collapse: collapse;
            background-color: #F2F2F2; /* Set your desired background color */
            margin-top: 10px; /* Optional: Add some space above the table */
            margin-left: 10px;
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

		.hd-h1, .img {
			font-family: Georgia, serif !important;
			padding-top: 20px !important;
			padding-left: 10px !important;
		}

        .hd-h3 {
            font-family: Georgia, serif !important;
			padding-top: 10px !important;
            padding-bottom: 10px !important;
			padding-left: 10px !important;
        }
        button {
            font-family: Georgia, serif !important;
			padding-left: 20px !important;
            padding-right: 20px !important;
            padding-top: 10px;
            padding-bottom: 10px;
            margin-top: 20px;
            margin-right: 20px;
            margin-left: 10px;
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

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

    // Get product name to search for
    // TODO: Retrieve and display info for the product
    String productID = request.getParameter("id");

    String sql = "SELECT productId, productName, productPrice, productDesc, productImageURL, productImage " +
                 "FROM product " +
                 "WHERE productId = ?";

    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, productID);

    ResultSet rst = pstmt.executeQuery();

    int productId = 0;
    String productName = "";
    double productPrice = 0;
    String productDesc = "";
    String productImageURL = "";
    byte[] productImage = null;

    if (rst.next()) {
        productId = rst.getInt(1);
	    productName = rst.getString(2);
		productPrice = rst.getDouble(3);
        productDesc = rst.getString(4);
		productImageURL = rst.getString(5);
        productImage = rst.getBytes(6);
    }       

    out.println("<h1 class=hd-h1>" + productName + "</h1>");
    out.println("<h3 class=hd-h3>Description: " + productDesc + "</h3>");
        
    //  TODO: If there is a productImageURL, display using IMG tag
    out.println("<table>");
    if (productImageURL != null) {
        out.println("<img class=img src=" + productImageURL + ">");
    }

    // TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
    if (productImage != null) {
        out.println("<img src=displayImage.jsp?id=" + productId + ">");
    }

    // Show product information
    out.println("<tr><th align=left>Id</th><td>" + productId + "</td></tr>"); 
    NumberFormat currFmt = NumberFormat.getCurrencyInstance();
    out.println("<tr><th align=left>Price</th><td>" + currFmt.format(productPrice) + "</td></tr></table>");

    // TODO: Add links to Add to Cart and Continue Shopping
    // out.println("<h3 class=hd-h3><a href=addcart.jsp?id=" + productId + "&name=" + java.net.URLEncoder.encode(productName, "UTF-8") + "&price=" + productPrice + ">Add to Cart</a></h3>");
    out.println("<form class=button action='addcart.jsp' method='GET'>");
    out.println("<input type='hidden' name='id' value='" + productId + "'>");
    out.println("<input type='hidden' name='name' value='" + java.net.URLEncoder.encode(productName, "UTF-8") + "'>");
    out.println("<input type='hidden' name='price' value='" + productPrice + "'>");
    out.println("<button type='submit' style='background-color: #638AB4; color: #FFFFFF; font-size: 20px;'>Add to Cart</button></form>");

    // If user is logged in, he may add a review
    userName = (String) session.getAttribute("authenticatedUser");
    if (userName != null){ 
        session.setAttribute("productId", productId);
        out.println("<h3 class=hd-h3><a href=addreview.jsp>Add Review</a></h3>");
    }

    out.println("<h3 class=hd-h3><a href=listprod.jsp>Continue Shopping</a></h3>");

    // Add Reviews here 
    sql = "SELECT reviewRating, reviewDate, reviewComment FROM review WHERE productId = ? ORDER BY reviewDate DESC";
    pstmt = con.prepareStatement(sql);
    pstmt.setInt(1, productId);
    rst = pstmt.executeQuery();

    if(!rst.next()){
        //no reviews available
        out.println("<h3 class=hd-h3>No Reviews Availbale</h3>");
    }else{
        out.println("<h3 class=hd-h3>Reviews</h3>");
        out.println("<table class=table border=1>");
        out.println("<tr><th>Rate</th><th>Date</th><th>Comment</th></tr>");
        do {
            int rate = rst.getInt(1);
            Timestamp timestamp = rst.getTimestamp(2);
            String datetime = timestamp.toString();
            String comment = rst.getString(3);

            // Display here
            out.println("<tr>");
		    out.println("<td>"+rate+"</td>");
		    out.println("<td>"+datetime+"</td>");
		    out.println("<td>"+comment+"</td>");
            out.println("</tr>");
        } while(rst.next());
        out.println("</table>");

    }


    con.close();
} catch (SQLException ex) {
	out.println("SQLException: " + ex);
}

%>

</body>
</html>

