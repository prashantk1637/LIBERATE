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
	min-height:520px;
	background:#76D7C4;
	float:left;
}
a{
text-decoration:none;
font-size:20px;
}
table{
border-collapse: collapse;
width:98%;
margin:1%;
}
td{
padding: 10px;
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
<h2 id="heading">New Notifications</h2>
		<%
PreparedStatement pstmt=null;
		String allCatchUp=null;
		int got=0;
String sql="select * from notification where mem_id=? and catchup=?";
try{
		Class.forName("com.mysql.jdbc.Driver");  
		Connection con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
		pstmt=(PreparedStatement) con.prepareStatement(sql);
		pstmt.setString(1, user);
		pstmt.setString(2, "NO");
		ResultSet rs=(ResultSet) pstmt.executeQuery();
		int serial_no=1;%>
		<table border=1 style="text-align:center;background:white">	
		<tr>
						<th>Serial No</th>
						<th>Notification</th>
						<th>Book Due Date/Renewal Date</th>
						<th>Notification received on</th>
						<th>Suggestions</th>
					</tr>
		<%while(rs.next()){%>		
				
				
				<tr><td><%=serial_no++ %></td>
						<td><%=rs.getString(3)%></td>
						<td><%=rs.getString(4)%></td>
						<td><%=rs.getString(5)%></td>
						<td>Please perform the action as soon as possible</td>
						</tr>
				
		<%}%>
		</table>
		<br/><br/><br/>
		<h2>Previous Notifications</h2>
		<table border=1 style="text-align:center;background:white">	
		<tr>
						<th>Serial No</th>
						<th>Notification</th>
						<th>Book Due Date/Renewal Date</th>
						<th>Notification received on</th>
						<th>Suggestions</th>
					</tr>
		
		<%	sql="select * from notification where mem_id=? and catchup=?";
			pstmt=(PreparedStatement) con.prepareStatement(sql);
			pstmt.setString(1, user);
			pstmt.setString(2, "YES");
			rs=(ResultSet) pstmt.executeQuery();
			serial_no=1;%>
			<%while(rs.next()){%>		
				
				
				<tr><td><%=serial_no++ %></td>
						<td><%=rs.getString(3)%></td>
						<td><%=rs.getString(4)%></td>
						<td><%=rs.getString(5)%></td>
						<td>Please perform the action as soon as possible</td>
						</tr>
				
		<%}%>
			
			<% sql="update notification set catchup=? where mem_id=? and catchup=?";
			pstmt=(PreparedStatement) con.prepareStatement(sql);
			pstmt.setString(1, "YES");
			pstmt.setString(2, user);
			pstmt.setString(3, "NO");
			pstmt.executeUpdate();
		
		
		
		%>
		</table>
	<%}catch(Exception e){}

%>

</div>
<script type="text/javascript">
<%if(allCatchUp!=null){%>
function CatchUp() {
	document.getElementById("heading").innerHTML='<%=allCatchUp%>'
	
}
window.onload=CatchUp;
<%}%>


</script>
</body>
</html>

