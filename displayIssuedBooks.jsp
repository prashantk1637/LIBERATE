<!--
******************************
Displays issued books details

******************************
-->
<%@page import="java.util.Calendar"%>
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
	height:500px;
	background:white;
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
td img{
width:80px;
height:100px;
background-image: url('/Liberate/books/no_preview.png')
}
table{
border-collapse: collapse;
width:98%;
margin:1%;
}
#footer{
	
	width:100%;
	height:100px;
	background:black;
	float:left;
	bottom: 0;
}

</style>

</head>

<body>
<%
	HttpSession s=request.getSession(false);
	String user=(String)s.getAttribute("user");
	String userType=(String)s.getAttribute("userType");
	Object obj=request.getAttribute("LIST");
	ArrayList<IssuedBookedDetailsBean> list=(ArrayList<IssuedBookedDetailsBean>)obj;
	String home="";
	if(userType.equals("librarian"))
		home="librarian.jsp";
	else
		home="member.jsp";
	
	DateFormat df=new SimpleDateFormat("dd/MM/yyyy");
	Date d=new Date();
	String issue_date=df.format(d);
	Calendar cal = Calendar.getInstance();    
	cal.setTime( df.parse(issue_date));    
	cal.add( Calendar.DATE, 21 );    
	String return_date=df.format(cal.getTime());    
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
	<li style="color:white" class="nav-item">Welcome!&nbsp;&nbsp;<span style="color:orange"><b><%=user%></b></span></li>
	<li class="nav-item"><a href="logout.jsp" style="color:red;"><b>Logout</b></a></li>
	<%} %>
	</ul>


</div>
<span style="font-size: 30px;">Issued books</span>
<div id="container">
		<table border=1 style="text-align:center;background:white">
					<tr>
						<th>Accession No</th>
						<th>View</th>
						<th>Title</th>
						<th>Author</th>
						<th>Edition</th>
						<th>ISBN</th>
						<th>Publisher</th>
						<th>Publication Year</th>
						<th>Request for issue Date</th>
						<th>Issue Date</th>
						<th>Return Date</th>
						<th>Issue Approval</th>
					</tr>
		<% for(IssuedBookedDetailsBean o: list){%>
			<%
			
				int accession_no=o.getAccession_no();
				String path=o.getPath();
				String title=o.getTitle();
				String author=o.getAuthor();
				String subject=o.getSubject();
				String edition=o.getEdition();
				String isbn=o.getIsbn();
				String publisher=o.getPublisher();
				int publication_year=o.getPublication_year();
				String mem_id=o.getMem_id();
				String req_for_issue_date=o.getReq_for_issue_date();
				String issue_date_db=o.getIssue_date();
				String return_date_db=o.getReturn_date();
				String issue_approval=o.getIssue_approval();%>
					<tr><td><%=accession_no %></td>
						<td><img src=<%=path %> /></td>
						<td><%=title%></td>
						<td><%=author%></td>
						<td><%=edition%></td>
						<td><%=isbn%></td>
						<td><%=publisher%></td>
						<td><%=publication_year%></td>
						<td><%=req_for_issue_date%></td>
						<%if(userType.equals("librarian")&& issue_approval.equals("pending")){ %>
						<form action="approved" method="post">
								<input type="hidden" name="accession_no" value=<%=accession_no %>>
								<input type="hidden" name="isbn" value=<%=isbn %>>
								<input type="hidden" name="mem_id" value=<%=mem_id%>>
								<input type="hidden" name="issue_date" value=<%=issue_date%> />
								<input type="hidden" name="return_date" value=<%=return_date%> />
								<td><%=issue_date %></td>
								<td><%=return_date %></td>	
								<td style="color: red"><%=issue_approval%>
							<input type="submit" value="Approve" /></td>
							</form>
							<%} %>
							<%if((userType.equals("student")||userType.equals("teacher"))&& issue_approval.equals("pending")) {%>
						<td>-</td>
						<td>-</td>
						<td style="color: red"><%=issue_approval%><span style="font-size:20px;"></span></td>
						<%}%>
						<%if(issue_approval.equals("issued")) {%>
							<td><%=issue_date_db %></td>
							<td><%=return_date_db %></td>
							<td style="color: green"><%=issue_approval%><span style="font-size:30px;"></span></td>
						<%} %>
						
						</tr>
				
		<%}%>
		</table>
</div>

</body>
</html>

