<%@page import="com.liberate.ReservedBookBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.liberate.IssuedBookedDetailsBean"%>
<%@page import="com.mysql.jdbc.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="com.mysql.jdbc.PreparedStatement"%>
<%@page import="com.mysql.jdbc.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
 <link rel="stylesheet" type="text/css" href="header.css"/>
<style type="text/css">
a{
text-decoration:none;
font-size:20px;
}
table{
border-collapse: collapse;
}
.key{
background:silver;
height:40px;
text-align: center;
font-weight: bold;
width: 200px;

}
.value
{
background:skyblue;
height:40px;
text-align: center;
width: 800px;
}
</style>
</head>
<body>
<%

	HttpSession s=request.getSession(false);
	String user=(String)s.getAttribute("user");
%>
<%if(user==null) {%>
<% response.sendRedirect("/Liberate?error=login+first");%>
<%} %>
<div id="header">
	<div id="logo"><img src="logo.png" alt="logo"/></div>
	<div id="banner"><img src="banner2.png" alt="image"/></div>
</div>

<div id="nav">
	<ul>
	<li class="nav-item" style="color:orange"><a href="member.jsp">home</a></li>
	<li class="nav-item"><a href="issuedDetails">Issue Book Status</a></li>
	<li class="nav-item"><a href="returnStatus">Return Books Status</a></li>
	<li class="nav-item" style="color:orange"><%="Welcome "+user%></li>
	<li class="nav-item"><a href="logout.jsp" style="color:red;"><b>Logout</b></a></li>
	</ul>


</div>
<%
		int accession_no=Integer.parseInt(request.getParameter("accession_no"));
		if(user==null)
			response.sendRedirect("/Liberate?error=Login+first");
		PreparedStatement pstmt=null,pstmt1=null;	
		String sql="delete from reserve where mem_id=? and accession_no=?";
		String sql1="delete from issue where mem_id=? and accession_no=?"; // to release pending book for issue 
																			//if member wants to releas								
		try{
				Class.forName("com.mysql.jdbc.Driver");  
				Connection con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
				pstmt=(PreparedStatement) con.prepareStatement(sql1);
				pstmt.setString(1,user);
				pstmt.setInt(2, accession_no);
				pstmt.executeUpdate();
				pstmt=(PreparedStatement) con.prepareStatement(sql);
				pstmt.setString(1,user);
				pstmt.setInt(2, accession_no);
				int flag=pstmt.executeUpdate();
				if(flag==1){
					RequestDispatcher rd=request.getRequestDispatcher("/reservedBoooks.jsp");
					rd.forward(request, response);
				}
				
			
		}catch(Exception e){}
%>

</body>
</html>