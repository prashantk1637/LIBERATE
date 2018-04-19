<!--
******************************
This is password change page
******************************
-->
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>
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
	background:skyblue;
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
width:50%;
height:30px;
border-radius: 3px;
cursor:pointer;
background-color: #4CAF50;
font-size:100%;
}
#notice
{
width: 36%;
height:40%;
margin-left: 32%;
margin-right: 32%;
background: orange;
margin-top: 20px;
padding: 10px;

}
</style>

</head>

<body>
<%
		HttpSession s=request.getSession(false);
		String user=(String)s.getAttribute("user");
		String userType=(String)s.getAttribute("userType");
		if(user==null)
			response.sendRedirect("/Liberate?error=Login+first");
		String home="";
		if(user!=null)
		{
			if(userType.equals("librarian"))
				home="librarian.jsp";
			else
				home="member.jsp";

		}
		DateFormat df=new SimpleDateFormat("dd/MM/yyyy");
		Date d=new Date();
		String today=df.format(d);
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
	<li class="nav-item"><a href="bookcatalog.jsp">Browse</a></li>
	<%} 
	else if(userType.equals("librarian")){%>
	<li class="nav-item"><a href="bookcatalog.jsp">Browse</a></li>
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
<%
String notice=request.getParameter("notice");
String notice_date=request.getParameter("notice_date");
String notice_link=request.getParameter("notice_link");
if(notice_link=="")
	notice_link=null;
String sql="insert into notice(notice,notice_date,notice_link) values(?,?,?)";
PreparedStatement pstmt;
Connection con;
String ispublish=null;
try {
	if(notice!=null && notice_date!=null)
	{	
			Class.forName("com.mysql.jdbc.Driver");
			con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");
			pstmt=(PreparedStatement) con.prepareStatement(sql);
			pstmt.setString(1,notice);
			pstmt.setString(2, notice_date);
			pstmt.setString(3, notice_link);
			int flag=pstmt.executeUpdate();
			if(flag==1)
			{
				ispublish="Notice published";	
			}
  }
}catch(Exception e){}
	


%>
<div id="container">
<div id="notice">
<h3 style="text-align: center">Publish a notice</h3>
<form action="notice.jsp" method="post">
				<table>
					<tr>
						<td><strong>Notice<span style="color:red">*</span></strong></td>
						<td><textarea  style="width: 180%;height:60px" name="notice" required/></textarea></td>
					</tr>
					<tr>
						<td><strong>Notice date<span style="color:red">*</span></strong></td>
						<td><input type="text" class="field" name="notice_date" value='<%=today%>' required /></td>
					</tr>
					<tr>
						<td><strong>Hyper link</strong></td>
						<td><input type="text" class="field" name="notice_link" placeholder="example:- http://www.example.com"/></td>
					</tr>
					<tr>
						<td></td>
						<td><input type="submit" class="btn" value="Publish" title="Publish the notice"/></td>
					</tr>
				</table>
				</form>
	</div>
		
</div>
<div id="footer">
<p style="text-align:center;color:white;">Copyright © All Rights Reserved 2017</p>

</div>
<script type="text/javascript">
<% if(ispublish!=null){%>
function Published()
{
alert('<%=ispublish%>');
}
window.onload=Published;
<%}%>
</script>
</body>
</html>

