<!--
******************************
This is login page

******************************
-->
<%@page import="com.mysql.jdbc.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="com.mysql.jdbc.Connection"%>
<%@page import="com.mysql.jdbc.PreparedStatement"%>
<%@page import="recommendation.UserSimilarity"%>
<%@page import="recommendation.ItemSimilarity"%>
<html>
<head>
<title>LIBERATE</title>
<link rel="stylesheet" type="text/css" href="index.css"/>
<style type="text/css">
#clock-div{
float: right;
}
</style>
</head>
<body>
<% String error=request.getParameter("error"); %>
<%
	HttpSession s=request.getSession(false);
	String user=(String)s.getAttribute("user");
	
	
%>
<%if(user!=null){%>
	<%
		String userType=(String)s.getAttribute("userType");
		if(userType.equals("librarian"))
		{
			response.sendRedirect("librarian.jsp");
		}
		else if(userType.equals("student")|| userType.equals("teacher"))
		{
			response.sendRedirect("member.jsp");
		}
	%>

<%}%>
<div id="header">
	<div id="logo"><img src="logo.png" alt="logo"/></div>
	<div id="banner"><img src="banner2.png" alt="image"/></div>
	<div id="clock-div"><%@ include file="clock1.html" %></div>
</div>

<div id="nav">
	<ul>
	<li class="nav-item"><a href="bookcatalog.jsp" title="List of all books">Browse</a></li>
	<li class="nav-item"><a href="search.jsp" title="Book Search">Book Search</a></li>
	<li class="nav-item"><a href="usefulBooks.jsp" title="Please look at some useful books">Useful books</a></li>
	<li class="nav-item"><a href="/Liberate/documentation/LIBERATEdoc.pdf" >About LIBERATE</a></li>
	<li class="nav-item"><a href="contact.html">Contact Us</a></li>

	</ul>


</div>
<div id="container">
	<div id="left">
		<div id="login">
			<form action="login" method="post">
				<table>
					<tr>
						<td><strong>Username</strong></td>
						<td><input type="text" title="Please enter your registered email address" class="field" name="user" required autocomplete="off" placeholder="registered email address"/></td>
					</tr>
					<tr>
						<td><strong>Password</strong></td>
						<td><input type="password" title="Please enter your password" class="field" name="pass" required placeholder="password"/></td>
					</tr>
					<tr>
						<td></td>
						<td><input type="submit" title="login" class="btn" value="Log In"/></td>
					</tr>
					<%if(error!=null) {%>
					<tr>
						<td></td>
						<td><p style="color:red;font-size:15px;"><%=error %></p></td>
					</tr>
					<%} %>
				</table>
			
			</form>
		</div>	
		<div id="notice-board">
			<div id="notice-board-header" >NOTICE BOARD</div>
			<div id="notice-content">
				<iframe  style="width:95%" src="/Liberate/noticeboard.jsp">
				</iframe>
				<a href="/Liberate/noticeboard.jsp">See more</a>
			</div>
		
		</div>
		<div id="notice-board" title="Policies Board">
			<div id="notice-board-header" >LIBERATE Polices</div>
			<div id="notice-content">
				<iframe  style="width:95%" src="/Liberate/policy.html">
				</iframe>
				<a href="/Liberate/policy.html">See more</a>
			</div>
		
		</div>

	</div>
	
	
	
	<div id="right">
	
	
	
	
	
	
	
	
	
	
	
	
	</div>
</div>
</body>
</html>
<%
//
%>
