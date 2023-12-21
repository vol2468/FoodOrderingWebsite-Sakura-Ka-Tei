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

        .hd-h1, .hd-h3 {
            font-family: Georgia, serif !important;
            padding-top: 20px !important;
            padding-left: 10px !important;
        }

    </style>
</head>
<body>

<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<% 
    // Display message here
    String message = (String)session.getAttribute("message");
    out.println("<h1 class=hd-h1>Message: " + message + "</h1>");
    session.removeAttribute("message");
%>

<h3 class=hd-h3><a href=listprod.jsp>Go Back to Product Page</a></h3>