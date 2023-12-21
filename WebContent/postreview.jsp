<%@ page import="java.sql.*" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.Timestamp, java.util.Date" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<%
    session = request.getSession(true);

    try
    {

        getConnection();
        String sql = null;
        PreparedStatement pstmt = null;
        ResultSet rst = null;

        int customerId = (int)session.getAttribute("customerId");
        int productId = (int)session.getAttribute("productId");
        String rating = request.getParameter("rating");
        int rate = Integer.parseInt(rating);
        String comment = request.getParameter("comment");
        Date currentDate = new Date();
        Timestamp timestamp = new Timestamp(currentDate.getTime());


        sql = "INSERT INTO review(reviewRating, reviewDate, customerId, productId, reviewComment)" +
                      "VALUES (?, ?, ?, ?, ?)";
        pstmt = con.prepareStatement(sql); 
        pstmt.setInt(1, rate);
        pstmt.setTimestamp(2, timestamp); 
        pstmt.setInt(3, customerId);
        pstmt.setInt(4, productId);
        pstmt.setString(5, comment);
        pstmt.executeUpdate();

        session.setAttribute("message","Successfully added your review. ");
        response.sendRedirect("message.jsp");

    }
    catch(Exception e)
    {
        System.err.println(e); 
        session.setAttribute("message",e.toString());
        response.sendRedirect("message.jsp");

    }
    finally{
        closeConnection();
    }


%>