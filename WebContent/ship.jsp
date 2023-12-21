<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Sakura Ka Tei Delivery Processing</title>
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

		.hd-h1, .hd-h2, .hd-h3  {
			font-family: Georgia, serif !important;
			padding-top: 20px !important;
			padding-left: 10px !important;
		}
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<%
	// TODO: Get order id
    String ordId = request.getParameter("orderId");

	// TODO: Check if valid order id in database
	boolean hasOrderId = ordId != null && !ordId.equals("");
	boolean validOrderId = false;

	String sql = "SELECT orderId FROM ordersummary WHERE orderId = ?";
	getConnection();
	PreparedStatement pstmt = con.prepareStatement(sql);
	ResultSet rst = null;

	int orderId = 0;
	if (!hasOrderId) {
		out.println("<h1 class=hd-h1>Invalid order id or no items in order.</h1>");
	} else {
		try {
			orderId = Integer.parseInt(ordId);
			pstmt.setInt(1, orderId);
			rst = pstmt.executeQuery();

			if (rst.next())
				validOrderId = true;
			else
				out.println("<h1 class=hd-h1>Invalid order id or no items in order.</h1>");
			
		} catch (Exception e) {
			out.println("<h1 class=hd-h1>Invalid order id or no items in order.</h1>");
		}
	}
	
	// TODO: Start a transaction (turn-off auto-commit)
	con.setAutoCommit(false);
	if (validOrderId) {
		// TODO: Retrieve all items in order with given id
		sql = "SELECT OP.productId, OP.quantity, warehouseId, PI.quantity " +
			  "FROM orderproduct AS OP JOIN productinventory AS PI ON OP.productId = PI.productId " +
			  "WHERE orderId = ?";
		pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, orderId);
		rst = pstmt.executeQuery();
		
		int productId = 0;
		int orderProductQty = 0;
		int warehouseId = 0;
		int preInventoryQty = 0;
		int insufficient = 0;
		int count = 0;
		out.println("<table class=table><tbody>");
		out.println("<tr><th>Order product</th><th>Quantity</th><th>Previous inventory</th><th>New inventory</th></tr>");
		while (rst.next() && count < 3) {
			productId = rst.getInt(1);
			orderProductQty = rst.getInt(2);
			warehouseId = rst.getInt(3);
			preInventoryQty = rst.getInt(4);
			count++;
			// Get the current time
			Timestamp timestamp = new Timestamp(System.currentTimeMillis());  
			String shipmentDate = timestamp.toString();

			String shipmentDesc = "Shipment of order id: " + orderId;

			// TODO: Create a new shipment record.
			String sql1 = "INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId) " +
				  		  "VALUES (?, ?, ?)";
			PreparedStatement pstmt1 = con.prepareStatement(sql1);	
			pstmt1.setString(1, shipmentDate);
			pstmt1.setString(2, shipmentDesc);
			pstmt1.setInt(3, warehouseId);
			pstmt1.executeUpdate();

			// TODO: For each item verify sufficient quantity available in warehouse 1.
			int newInventoryQty = preInventoryQty - orderProductQty;
			// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
			if (orderProductQty > preInventoryQty) {
				con.rollback();
				insufficient++;
			} else {
				String sql2 = "UPDATE productinventory SET quantity = ? " +
							  "WHERE productId = ?";
				PreparedStatement pstmt2 = con.prepareStatement(sql2);	
				pstmt2.setInt(1, newInventoryQty);
				pstmt2.setInt(2, productId);
				pstmt2.executeUpdate();
				// out.println("<tr><th>Order product</th><td>" + productId + "</td><th>Quantity</th><td>" + orderProductQty + "</td><th>Previous inventory</th><td>" + preInventoryQty + "</td><th>New inventory</th><td>" + newInventoryQty + "</td></tr>");
				out.println("<tr><td>" + productId + "</td><td>" + orderProductQty + "</td><td>" + preInventoryQty + "</td><td>" + newInventoryQty + "</td></tr>");
			}
		}
		out.println("</tbody></table>");

		if (insufficient == 0) {
			con.commit();
			out.println("<h2 class=hd-h2>Successfully delivered.</h2>");
		} else {
			con.rollback();
			out.println("<h2 class=hd-h2>Delivery not done. Insufficient inventory for product id: " + productId + "</h2>");
		}

	}
	// TODO: Auto-commit should be turned back on
	con.setAutoCommit(true);
	closeConnection();
%>                       				

<h2 class=hd-h2><a href="index.jsp">Back to Main Page</a></h2>

</body>
</html>
