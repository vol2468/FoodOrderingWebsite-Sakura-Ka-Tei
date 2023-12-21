<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Your Shopping Cart</title>
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

		.hd-h2 {
			font-family: Georgia, serif !important;
			padding-top: 10px !important;
			padding-left: 10px !important;
		}
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<!-- Taii Hirano, 44551257 -->
<!-- Yuki Isomura, 11888757 -->

<%-- <h1 align=center><font face=cursive color=#3399FF>Taii's Nandemo Grocery</font></h1> --%>

<script>
function update(newid, newqty)
{
	window.location="showcart.jsp?update="+newid+"&newqty="+newqty;
}
</script>

<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null)
{	out.println("<h1 class=hd-h1>Your shopping cart is empty!</h1>");
	productList = new HashMap<String, ArrayList<Object>>();
}
else
{
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	out.println("<h1 class=hd-h1>Your Shopping Cart</h1>");
	out.print("<table class=table border=1><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
	out.println("<th>Price</th><th>Subtotal</th><th></th><th></th></tr>");

	// Handle removing items
	String deleteId = request.getParameter("delete");
	if (deleteId != null) {
		productList.remove(deleteId);
	}

	// Handle new quantity
	String newid = request.getParameter("update");
	String newqty = request.getParameter("newqty");
	int newQuantity = 0;
	if (newid != null && newqty != null) {
		try {
			newQuantity = Integer.parseInt(newqty);
		} catch (Exception e) {
			out.println("Invalid quantity for product: " + newid + " quantity: " + newqty);
		}
		ArrayList<Object> newProduct = (ArrayList<Object>) productList.get(newid);
		newProduct.set(3, new Integer(newQuantity));
		productList.put(newid, newProduct);
	}

	double total =0;
	int count = 1;
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext()) 
	{	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		if (product.size() < 4)
		{
			out.println("Expected product with four entries. Got: "+product);
			continue;
		}
		
		Object productId = product.get(0);
		Object productName = product.get(1);

		out.print("<tr><td>"+product.get(0)+"</td>");
		out.print("<td>"+product.get(1)+"</td>");

		// out.print("<td align=\"center\">"+product.get(3)+"</td>");
		Object price = product.get(2);
		Object itemqty = product.get(3);
		double pr = 0;
		int qty = 0;

		try
		{
			pr = Double.parseDouble(price.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid price for product: "+product.get(0)+" price: "+price);
		}
		try
		{
			qty = Integer.parseInt(itemqty.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid quantity for product2: "+product.get(0)+" quantity: "+qty);
		}	
	
		out.print("<form name=form1>");
		out.print("<td align=center><input type=text name=newqty" + count + "1 size=3 value=" + qty + "></td>");
		out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
		out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td>");
		out.print("<td>&nbsp;&nbsp;&nbsp;&nbsp;<a href=showcart.jsp?delete=" + productId + ">Remove Item from Cart</a></td>");
		out.print("<td>&nbsp;&nbsp;&nbsp;&nbsp;<input type=button onclick=\"update(" + productId + ",document.form1.newqty" + count + "1.value)\" value=\"Update Quantity\"></tr>");

		total = total +pr*qty;
		count++;
	}
	out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
			+"<td align=\"right\">"+currFormat.format(total)+"</td></tr>");
	out.println("</table>");

	out.println("<h2 class=hd-h2><a href=\"checkout.jsp\">Check Out</a></h2>");

	out.println("</form>");
}
%>
<h2 class=hd-h2><a href="listprod.jsp">Continue Shopping</a></h2>
</body>
</html> 

