<!--
******************************
Show all copies of a book

******************************
-->
<%@page import="com.liberate.AllCopiesOfAbookBean"%>
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
	min-height:500px;
	background:silver;
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
width:100px;
height:30px;
border-radius: 3px;
cursor:pointer;
background-color: #4CAF50;
font-size: 15px;
}
td img{
width:80px;
height:100px;
}
table{
width:100%;
border-collapse: collapse;
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
	ArrayList<AllCopiesOfAbookBean> list=(ArrayList<AllCopiesOfAbookBean>)obj;
	String home="";
	%>
	<div id="header">
		<div id="logo"><img src="logo.png" alt="logo"/></div>
		<div id="banner"><img src="banner2.png" alt="image"/></div>
	</div>

	<div id="nav">
		<ul>
		<%if(user!=null){
			if(userType.equals("librarian"))
				home=""+"librarian.jsp";
			else home=""+"member.jsp";
			%>
			
		<li class="nav-item"><a href=<%=home %>>Home</a></li>
		<%} %>
		<%if(user==null){%>
		<li class="nav-item"><a href="/Liberate">Login Here</a></li>
		<%} %>
		
		<%if(userType==null){%>
		<li class="nav-item"><a href="catalog">Browse</a></li>
		<%} %>
		
		<%if(userType.equals("librarian")){%>
		<li class="nav-item"><a href="catalog">Browse</a></li>
		<%} %>
		<%if(userType.equals("student")|| userType.equals("teacher")){%>
		<li class="nav-item"><a href="bookCatalog">Browse</a></li>
		<%} %>
		
		
		
		<li class="nav-item"><a href="search.jsp">Search</a></li>
		<%if(user!=null){%>
		<li style="color:white" class="nav-item">Welcome!&nbsp;&nbsp;<span style="color:orange"><b><%=user%></b></span></li>
		<li class="nav-item"><a href="logout.jsp" style="color:red;"><b>Logout</b></a></li>
		<%} %>
		</ul>

</div>

<div id="container">
<%
DateFormat df=new SimpleDateFormat("dd/MM/yyyy");
Date d=new Date();
String req_for_issue_date=df.format(d);
%>
		<table border=1 style="text-align:center;background:white">
					<tr>
						<th>Accession No.</th>
						<th>Title</th>
						<th>Author</th>
						<th>Edition</th>
						<th>Status</th>
						<td></td>
					</tr>
		<% for(AllCopiesOfAbookBean o: list){%>
			<%
			
				int accession_no=o.getAccession_no();
				String title=o.getTitle();
				String author=o.getAuthor();
				String edition=o.getEdition();
				String isbn=o.getIsbn();
				String status=o.getStatus();%>
					<tr>
						<td><%=accession_no %></td>
						<td><%=title%></td>
						<td><%=author%></td>
						<td><%=edition%></td>
						<td><%=status %></td>
						<%if(status.equals("Issued")&& !userType.equals("librarian")) {%>
						<td>
							<form action="reserve" method="post">
				
								<input type="hidden" name="accession_no" value=<%=accession_no %> />
								<input type="hidden" name="mem_id" value=<%=user %> />
								<input type="hidden" name="mem_type" value=<%=userType %> />
								<input type="hidden" name="isbn" value=<%=isbn %> />
								<input type="hidden" name="reserve_date" value=<%=req_for_issue_date %>>
								<input type="submit" value="RESERVE" class="btn" style="background:orange" />
							</form>
						</td>
						<%} %>
						<%if(status.equals("Available")&&!userType.equals("librarian")) {%>
						<td>
							<form action="history" method="post">
				
								<input type="hidden" name="accession_no" value=<%=accession_no %> />
								<input type="hidden" name="mem_id" value=<%=user %> />
								<input type="hidden" name="mem_type" value=<%=userType %> />
								<input type="hidden" name="isbn" value=<%=isbn %> />
								<input type="hidden" name="req_for_issue_date" value=<%=req_for_issue_date %>>
								<input type="submit" value="ISSUE" class="btn" />
				</form>
						</td>
						<%} %>
					
					</tr>
				
				
		<%} %>
		</table>
</div>
<div id="footer">
<p style="text-align:center;color:white;">Copyright© All Rights Reserved 2017</p>

</div>
</body>
</html>

