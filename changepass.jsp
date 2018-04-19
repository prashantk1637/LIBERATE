<!--
******************************
This is password change page
******************************
-->
<%@page import="com.mysql.jdbc.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="com.mysql.jdbc.Connection"%>
<%@page import="com.mysql.jdbc.PreparedStatement"%>
<html !DOCTYPE="html">
<head>
<title>LIBERATE</title>
 <link rel="stylesheet" type="text/css" href="header.css"/>
<style>
#container{
	
	width:100%;
	min-height:500px;
	background:#76D7C4;
	float:left;
}
a{
text-decoration:none;
font-size:20px;
}
#footer{
	
	width:100%;
	height:100px;
	background:black;
	float:left;
}
.field{
width:180%;
height:30px;
border-radius:5px;
}
.btn{
height:30px;
width:100px;
border-radius: 3px;
cursor:pointer;
}
</style>

</head>

<body>
<%
		HttpSession s=request.getSession(false);
		String user=(String)s.getAttribute("user");
		String userType=(String)s.getAttribute("userType");
		String home="";
		if(user!=null)
		{
			if(userType.equals("librarian"))
				home="librarian.jsp";
			else
				home="member.jsp";

		}
%>
<div id="header">
	<div id="logo"><img src="logo.png" alt="logo"/></div>
	<div id="banner"><img src="banner2.png" alt="image"/></div>
</div>

<div id="nav">
	<ul>
	<%if(user==null){%>
	<li class="nav-item"><a href="index.jsp">Login Here</a></li>
	<%} %>
	<%if(user!=null){%>
	<li class="nav-item"><a href=<%=home %> onclick="home()">Home</a></li>
	<%} %>
	<%if(userType==null){%>
	<li class="nav-item"><a href="catalog">Browse</a></li>
	<%} 
	else if(userType.equals("librarian")){%>
	<li class="nav-item"><a href="catalog">Browse</a></li>
	<%} 
	else if(userType.equals("student")|| userType.equals("teacher")){%>
	<li class="nav-item"><a href="bookCatalog">Browse</a></li>
	<%} %>
	<%if(user!=null){%>
		<li style="color:white" class="nav-item">Welcome!&nbsp;&nbsp;<span style="color:orange"><b><%=user%></b></span></li>
		
	<%}%>
	<%if(user!=null){%>
		<li class="nav-item"><a href="logout.jsp" style="color:red;"><b>Logout</b></a></li>
		<%}%>
	</ul>


</div>
<div id="container">

<%
if(user==null)
	response.sendRedirect("/Liberate?error=Login+first");
String cpass=request.getParameter("cpass");
String npass=request.getParameter("npass");
String check_query="select email,password from member where email=? and password=?";
String sql="UPDATE member SET password=? where email=?";
String sql1="UPDATE login SET password=? where email=?";
PreparedStatement pstmt,checkpstmt;
Connection con;
try {
	Class.forName("com.mysql.jdbc.Driver");
	con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");
	checkpstmt=(PreparedStatement) con.prepareStatement(check_query);
	checkpstmt.setString(1, user);
	checkpstmt.setString(2, cpass);
	ResultSet rs=(ResultSet)checkpstmt.executeQuery();
	if(rs.next())
	{
		pstmt=(PreparedStatement) con.prepareStatement(sql);
		pstmt.setString(1, npass);
		pstmt.setString(2, user);
		int flag=pstmt.executeUpdate();
		if(flag==1)
		{
			PreparedStatement pstmt1=(PreparedStatement) con.prepareStatement(sql1);
			pstmt1.setString(1, npass);
			pstmt1.setString(2, user);
			pstmt1.executeUpdate();
			request.setAttribute("passchanged","password changed");
			RequestDispatcher rd=request.getRequestDispatcher("/profile.jsp");
			rd.forward(request, response);
		}
	}
	if(!rs.next() && cpass!=null){
		out.print("<span style='color:red'>Wrong current password</span>");
	}
	
	}catch(Exception e){}


%>
<form action="changepass.jsp" method="post">
				<table>
					<tr>
						<td><strong>Current Password</strong></td>
						<td><input type="password" class="field" name="cpass" required/></td>
					</tr>
					<tr>
						<td><strong>New Password</strong></td>
						<td><input type="password" class="field" name="npass" required /></td>
					</tr>
					<tr>
						<td></td>
						<td><input type="submit" class="btn" value="Change"/></td>
					</tr>
				</table>
				</form>
		
</div>
<div id="footer">
<p style="text-align:center;color:white;">Copyright © All Rights Reserved 2017</p>

</div>
</body>
</html>

