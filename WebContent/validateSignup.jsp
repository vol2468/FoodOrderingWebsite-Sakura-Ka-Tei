<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ page import="java.util.regex.Pattern, java.util.regex.Matcher" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);

	try
	{
		authenticatedUser = validateSignup(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null)
		response.sendRedirect("index.jsp");		// Successful sign up
	else
		response.sendRedirect("signup.jsp");	// Failed sign up - redirect back to sign up page with a message 
%>

<%!
    
	String validateSignup(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		// Todo: validate user entered information
        // Todo: return either authenticatedUser or error message

        // Retrieve input information
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phonenum = request.getParameter("phonenum");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String postalCode = request.getParameter("postalCode");
        String country = request.getParameter("country");
        String username = request.getParameter("username");
		String password = request.getParameter("password");


        // input blank check
        if(firstName == null || 
            lastName == null ||
            email == null ||
            phonenum == null ||
            address == null ||
            city == null ||
            state == null ||
            postalCode == null ||
            country == null ||
            username == null ||
            password == null )
        {
            session.setAttribute("signupMessage","At least one of the field is missing. ");
            return null;
        }
		if(firstName.isBlank() || 
            lastName.isBlank() || 
            email.isBlank() || 
            phonenum.isBlank() || 
            address.isBlank() || 
            city.isBlank() || 
            state.isBlank() || 
            postalCode.isBlank() || 
            country.isBlank() || 
            username.isBlank() || 
            password.isBlank())
        {
            session.setAttribute("signupMessage","At least one of the field is missing. ");
            return null;
        }

        // Check email form validity
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        Pattern pattern = Pattern.compile(emailRegex);
        Matcher matcher = pattern.matcher(email);
        boolean validEmail = matcher.matches();
        if(!validEmail){
            session.setAttribute("signupMessage","Invalid email form. ");
            return null;
        }
        // Check phone number form validity
        boolean phoneIsNum = true;
        String temp =  "";
        try{
            Long.parseLong(phonenum);
        }catch (Exception e){
            phoneIsNum = false;
            temp = "1";

        } 
        if(phonenum.length() != 10 || !phoneIsNum){
            session.setAttribute("signupMessage","Invalid phone number form. It has to be 10 digit number. ");
            return null;
        }
        String phone = String.format("(%s)-%s-%s", phonenum.substring(0, 3), phonenum.substring(3, 6), phonenum.substring(6, 10));
        
        
        // check if same userId already exists
		String retStr = null;
        try 
        {
            getConnection();
            String sql = "SELECT userid, password " +
						 "FROM customer " +
						 "WHERE userid = ?";
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setString(1, username);
			ResultSet rst = pstmt.executeQuery();

            if (!rst.next()) { // if userId does not exists
                retStr = username;
                // store new customer in database
                sql = "INSERT INTO customer (firstName, lastName, email, phonenum, address, " + 
                                            "city, state, postalCode, country, userid, password) " + 
                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                pstmt = con.prepareStatement(sql);
                pstmt.setString(1, firstName);
                pstmt.setString(2, lastName);
                pstmt.setString(3, email);
                pstmt.setString(4, phone);
                pstmt.setString(5, address);
                pstmt.setString(6, city);
                pstmt.setString(7, state);
                pstmt.setString(8, postalCode);
                pstmt.setString(9, country);
                pstmt.setString(10, username);
                pstmt.setString(11, password);
                pstmt.executeUpdate();
			}
        }
        catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			closeConnection();
		}	

		if(retStr != null)
		{	session.removeAttribute("signupMessage");
			session.setAttribute("authenticatedUser",username);
		}
		else
			session.setAttribute("signupMessage","User Id you specified is already used. ");

		return retStr;
	}
%>