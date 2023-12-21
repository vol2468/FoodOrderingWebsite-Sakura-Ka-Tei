<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
        }

        header {
            background-color: #333;
            padding: 15px;
            height: 100px; /* Adjust the height as needed */
            color: white;
            display: flex;
            align-items: center; /* Center items vertically */
            justify-content: space-between; /* Distribute items along the main axis */
            text-align: center;
        }

        header img {
            max-width: 100%;
            height: auto;
            max-height: 100px; /* Set a maximum height for the image if needed */
            margin-right: 20px; /* Adjust the margin as needed */
        }

        .header-container a {
            font-family: Georgia, serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 0;
            margin: 0;
        }

        h1, h3 {
            margin: 0;
            padding: 0;
        }

        nav {
            display: flex;
            justify-content: center;
        }

        nav a {
            color: white;
            text-decoration: none;
            padding: 10px;
            margin: 10px;
        }

        .login-out {
            display: felx;
            flex-direction: column;
        }
    </style>
</head>
<body>
    <header>
        <img src="img/logo.png" alt="Logo">
        <div class="header-container">
            <div class="header-h1">
                <h1 align="center"><font face="cursive" color="#3399FF"><a href="index.jsp">Sakura Ka Tei</a></font></h1>
            </div>
            <div class="header-h3">
                <h3 align="center"><font face="cursive" color="#3399FF"><a href="index.jsp">~Authentic Japanese Gastronomy~</a></font></h3>
            </div>
        </div>
        <nav>
            <a href="index.jsp">Home</a>
            <a href="listprod.jsp">Shopping</a>
            <a href="listorder.jsp">Orders</a>
            <a href="customer.jsp">Customer</a>
            <a href="admin.jsp">Administrators</a>
            <a href="showcart.jsp">Cart</a>
            <%
                String userName = (String) session.getAttribute("authenticatedUser");
                if (userName != null) {
                    out.println("<div class=login-out>");
                    out.println("<p>Signed in as: "+userName+"</p>");
                    out.println("<a href=logout.jsp>Logout</a>");
                    out.println("</div>");
                }
                else {
                    out.println("<a href=login.jsp>Login</a>");
                }
            %>
            <%-- <a href="login.jsp">Login</a> --%>
            <%-- <a href="logout.jsp">Logout</a> --%>
        </nav>
    </header>

    <!-- Rest of your page content goes here -->

</body>
</html>

