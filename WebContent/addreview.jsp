<!DOCTYPE html>
<html>
<head>
<title>Add Review Page</title>
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
        .form-fm, .para-p {
			margin: 20px !important;
		}
        .submit {
            margin-top: 20px !important;
        }
    </style>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<%
    session = request.getSession(true);
    userName = (String) session.getAttribute("authenticatedUser");
    int productId = (int) session.getAttribute("productId");

    try 
    {
        getConnection();
        String sql = null;
        PreparedStatement pstmt = null;
        ResultSet rst = null;

        // Write title
		out.print("<h1 class=hd-h1>Write a review</h1>");

		// Retrieve userId 
		sql = "SELECT customerId FROM customer WHERE userid = ?";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, userName);
		rst = pstmt.executeQuery();
		int customerId = -1;
		if (rst.next()) {
			customerId = rst.getInt(1);
		}

        sql = "SELECT reviewId FROM review WHERE customerId = ? AND productId = ?";
        pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, customerId);
        pstmt.setInt(2, productId);
        rst = pstmt.executeQuery();
        if (rst.next()) { // If review form the same user for the same product already exists
            session.setAttribute("message", "Your review for this product already exists");
            response.sendRedirect("message.jsp");
		} 

        // Check if the user has purchased this item before
        sql = "SELECT ordersummary.orderId " + 
              "FROM ordersummary JOIN orderproduct ON ordersummary.orderId = orderproduct.orderId " + 
              "WHERE customerId = ? AND productId = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, customerId);
        pstmt.setInt(2, productId);
        rst = pstmt.executeQuery();
        if (!rst.next()) { // If the user has never purchased the item  
            session.setAttribute("message", "You have never purchased this item yet. ");
            response.sendRedirect("message.jsp");
		} 
        

        session.setAttribute("customerId", customerId);
        session.setAttribute("productId", productId);        
    } catch (SQLException e) {
        session.setAttribute("message", e.toString());
        response.sendRedirect("message.jsp");
    } finally {
        closeConnection();
    }

%>

<%-- Write Review --%>

<form class=form-fm method="post" action=postreview.jsp>
    <div>
        <label for="rating">Rating:</label>
        <input type="radio" name="rating" value="1" id="rating1"><label for="rating1">1</label>
        <input type="radio" name="rating" value="2" id="rating2"><label for="rating2">2</label>
        <input type="radio" name="rating" value="3" id="rating3"><label for="rating3">3</label>
        <input type="radio" name="rating" value="4" id="rating4"><label for="rating4">4</label>
        <input type="radio" name="rating" value="5" id="rating5"><label for="rating5">5</label>
    </div>

    <div>
        <label for="comment">Comment:</label>
        <textarea name="comment" id="comment" rows="4" cols="50"></textarea>
    </div>

    <div>
        <input class=submit type="submit" value="Post Review">
    </div>
</form>
