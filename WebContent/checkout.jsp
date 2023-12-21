<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Sakura Ka Tei CheckOut Line</title>
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
			<%-- margin: 20px; /* Optional: Add some space above the table */ --%>
			margin: 0 auto;
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
			margin-bottom: 20px;
		}
    </style>
</head>
<body>

<%@ include file="header.jsp" %>
<%@ include file="jdbc.jsp" %>

<!-- Taii Hirano, 44551257 -->
<!-- Yuki Isomura, 11888757 -->

<%-- <h1 align=center><font face=cursive color=#3399FF>Taii's Nandemo Grocery</font></h1> --%>

<div style="margin:0 auto;text-align:center;display:inline">
<h1 class=hd-h1>Enter your customer id and payment information to complete the transaction:</h1>

<form action = "order.jsp" method="post">
  <table>
		<tbody>
			<tr>
				<td>
					<label for="customerId">CustomerID:</label>
				</td>
				<td>
					<input type="text" id="customerId" name="customerId" required>
				</td>
			</tr>
			<tr>
				<td>
					<label for="password">Password:</label>
				</td>
				<td>
					<input type="password" id="password" name="password" required>
				</td>
			</tr>
			<tr>
				<td>
					<label for="paymenttype">Payment Type:</label>
				</td>
				<td>
					<input type="radio" id="visa" name="paymenttype" value="VISA" required>
  					<label for="visa">VISA</label><br>
  					<input type="radio" id="master" name="paymenttype" value="Mastercard" required>
  					<label for="master">Mastercard</label><br>
  					<input type="radio" id="paypal" name="paymenttype" value="PayPal" required>
  					<label for="paypal">PayPal</label><br>
					<input type="radio" id="applepay" name="paymenttype" value="Apple Pay" required>
  					<label for="paypal">Apple Pay</label>
				</td>
			</tr>
			<tr>
				<td>
					<label for="paymentnumber">Payment Number:</label>
				</td>
				<td>
					<input type="text" id="paymentnumber" name="paymentnumber" required>
				</td>
			</tr>
			<tr>
				<td>
					<label for="paymentexpirydate">Expiry Date:</label>
				</td>
				<td>
					<input type="text" id="paymentexpirydate" name="paymentexpirydate" required>
				</td>
			</tr>
			<tr>
				<td>
					<button type="reset">Reset</button>
				</td>
				<td>
					<button type="submit">Submit</button>
				</td> 
			</tr>
		</tbody>
  	</table>
</form>
</div>

</body>
</html>