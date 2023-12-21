<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>
<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: Georgia, serif !important;
			margin: 20px !important; /* Use !important to increase specificity */
        }

        table {
            width: 100% !important;
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

<%
// TODO: Include files auth.jsp and jdbc.jsp
%>
<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<%

// TODO: Write SQL query that prints out total order amount by day
String sql = "SELECT YEAR(orderDate), MONTH(orderDate), DAY(orderDate), SUM(totalAmount) " +
             "FROM ordersummary " +
             "GROUP BY YEAR(orderDate), MONTH(orderDate), DAY(orderDate)";

String sql2 = "SELECT customerId, firstName, lastName FROM customer";

getConnection();
PreparedStatement pstmt = con.prepareStatement(sql);
PreparedStatement pstmt2 = con.prepareStatement(sql2);
ResultSet rst = pstmt.executeQuery();
ResultSet rst2 = pstmt2.executeQuery();

out.println("<div style='display: flex;'>");  // Use flexbox to position tables side by side

out.println("<div style='flex: 1; margin-right: 20px;'>");  // Add some margin between the tables

out.println("<h1 class=hd-h1>Administrator Sales Report by Day</h1>");
out.println("<table class=table1 border=1><tr><th>Order Date</th><th>Total Order Amount</th></tr>");

ArrayList<String> dates = new ArrayList<>();
ArrayList<String> sales =  new ArrayList<>();
double sum = 0;
int count = 0;
while (rst.next()) {
    int orderYear = rst.getInt(1);
    int orderMonth = rst.getInt(2);
    int orderDay = rst.getInt(3);
    String orderDate = orderYear + "-" + orderMonth + "-" + orderDay;
    dates.add(orderDate);
    double totalOrderAmount = rst.getDouble(4);
    sales.add(Double.toString(totalOrderAmount));
    sum += totalOrderAmount;
    NumberFormat currFmt = NumberFormat.getCurrencyInstance();
    out.println("<tr><td>" + orderDate + "</td><td style='text-align: right;'>" + currFmt.format(totalOrderAmount) + "</td></tr>");
    count++;
}
NumberFormat currFmt = NumberFormat.getCurrencyInstance();
out.println("<tr><th>Total</th><td style='text-align: right;'>" + currFmt.format(sum) + "</td></tr>");
out.println("</table>");
out.println("</div>");  // Close the div for the first table

out.println("<div style='flex: 1;'>");
out.println("<h1 class=hd-h1>Customer List</h1>");
out.println("<table class=table border=1><tr><th>Customer ID</th><th>Name</th></tr>");

while (rst2.next()) {
    int customerId = rst2.getInt(1);
    String firstName = rst2.getString(2);
    String lastName = rst2.getString(3);
    String name = firstName + " " + lastName;
    out.println("<tr><td>" + customerId + "</td><td>" + name + "</td></tr>");
}
out.println("</table>");
out.println("</div>");  // Close the div for the second table

closeConnection();
%>

</body>
</html>

