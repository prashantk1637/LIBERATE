<!--
******************************
Shows list of returned books 
******************************
-->
<%@page import="com.liberate.ReturnStatusBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.liberate.IssuedBookedDetailsBean"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.liberate.BookFullDetailsBean"%>
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
#right li{
list-style:none;
margin:2px;
background:silver;
padding:5px;
margin-right:50%;
text-align:center;
border-radius:10px;
}
a{
text-decoration:none;
font-size:20px;
}
.btn{
height:25px;
width:80px;
border-radius: 10px;
background:green;
cursor:pointer;
color:white;
}
table{
border-collapse: collapse;
width:98%;
margin-top:1%;
margin-left: 1%;
margin-right: 1%;
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

</style>

</head>

<body>
<%
	HttpSession s=request.getSession(false);
	String user=(String)s.getAttribute("user");
	String userType=(String)s.getAttribute("userType");
	Object obj=request.getAttribute("LIST");
	ArrayList<ReturnStatusBean> list=(ArrayList<ReturnStatusBean>)obj;
	String home="";
	if(userType.equals("librarian"))
		home="librarian.jsp";
	else
		home="member.jsp";
%>
<div id="header">
	<div id="logo"><img src="logo.png" alt="logo"/></div>
	<div id="banner"><img src="banner2.png" alt="image"/></div>
</div>

<div id="nav">
	<ul>
	<li class="nav-item"><a href=<%=home%>>Home</a></li>
	
	<%if(userType.equals("librarian")){%>
	<li class="nav-item"><a href="catalog">Browse</a></li>
	<%} %>
	<%if(userType.equals("student")|| userType.equals("teacher")){%>
	<li class="nav-item"><a href="bookCatalog">Browse</a></li>
	<%} %>
	
	<li class="nav-item"><a href="search.jsp">Search</a></li>
	<%if(user!=null){%>
		<li class="nav-item" style="color:white">Welcome!&nbsp;&nbsp;<span style="color:orange"><b><%=user%></b></span></li>
		<li class="nav-item"><a href="logout.jsp" style="color:red;"><b>Logout</b></a></li>
	<%} %>
	</ul>


</div>
<span style="font-size: 30px;">Returned books</span>
<div id="container">
		<table border=1 style="text-align:center;background:white">
					<tr>
						<th>Accession No</th>
						<th>Your member id</th>
						<th>Member type</th>
						<th>Issue Date</th>
						<th>Due Date</th>
						<th>Return Date</th>
						<th>Fine paid</th>
						<th>Return Approval</th>
					</tr>
		<% for(ReturnStatusBean o: list){%>
			<%
			
				int accession_no=o.getAccession_no();
				String mem_id=o.getMem_id();
				String mem_type=o.getMem_type();
				String issue_date=o.getIssue_date();
				String due_date=o.getDue_date();
				String return_date=o.getReturn_date();
				int fine_paid=o.getFine_paid();
				String return_approval=o.getReturned_approval();%>
					<tr>
						<td><%=accession_no %></td>
						<td><%=mem_id%></td>
						<td><%=mem_type%></td>
						<td><%=issue_date%></td>
						<td><%=due_date%></td>
						<td><%=return_date%></td>
						<td><%=fine_paid%></td>
						<td><%=return_approval%></td>
					</tr>
				
				
		<%} %>
		</table>
</div>
</body>
</html>

