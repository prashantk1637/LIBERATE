<!--
******************************
it display the particular book
which member wants to request
for book issue
******************************
-->
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
.field{
width:150%;
height:25px;
border-radius:5px;
}
.btn{
width:100px;
height:30px;
border-radius: 3px;
cursor:pointer;
background-color: #4CAF50;
font-size: 15px;
color:white;
}
#top-content{
width:96%;
float:left;
height:50px;
margin-top:4px;
margin-left:2%;
margin-right:2%;
}
#left{
width:70%;
background:white;
float:left;
height:400px;
margin-left:2%;
}
#right{
width:25.5%;
background:white;
float:left;
height:400px;
margin-left:.5%;
margin-right:2%;
}
#left #book-img{
width:30%;
height:80%;
margin-left:10px;
margin-top:10px;
float:left;
text-align: center;
box-sizing: border-box;
border: 1px solid silver;
background-image: url('/Liberate/books/no_image.png');
cursor: zoom-in;
}

#left #book-img:HOVER{
width:35%;
height:100%;
margin-left:0px;
margin-top:0px;
}
#book-desc
{
width:60%;
height:80%;
margin-left:10px;
margin-top:10px;
float:left;
}
#book-desc #head{
border-bottom: solid 1px silver;
text-align:center;
font-size:100%;
}
#book-desc #body{
border-bottom: solid 1px silver;
font-size:100%;
}
#book-desc #foot{
border-bottom: solid 1px silver;
font-size:100%;
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
	
	Object obj=request.getAttribute("OBJ");
	BookFullDetailsBean o=(BookFullDetailsBean)obj;
	String home="";
	
	

%>
<%String status=request.getParameter("status"); %>
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
	<%} 
	else if(userType.equals("librarian")){%>
	<li class="nav-item"><a href="catalog">Browse</a></li>
	<%} 
	else if(userType.equals("student")|| userType.equals("teacher")){%>
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
		int accession_no=o.getAccession_no();
		String path=o.getPath();
		String title=o.getTitle();
		String author=o.getAuthor();
		String subject=o.getSubject();
		String edition=o.getEdition();
		String isbn=o.getIsbn();
		String publisher=o.getPublisher();
		int publication_year=o.getPublication_year();
		String availability=o.getAvailability();
		
		DateFormat df=new SimpleDateFormat("dd/MM/yyyy");
		Date d=new Date();
		String issue_date=df.format(d);
		%>
	<div id="top-content">
		<span style="font-size:30px;margin-left:80px;font-style:italic">Book Details</span>
	</div>
	<div id="left">
		<div id="book-img"><img src=<%=path %>></div>
		<div id="book-desc">
			<div id="head"><p><b><%=title %></b></p></div>
			<div id="body">
				<p><i>Author:</i>&nbsp;<%=author %></p>
				<p><i>Subject:</i>&nbsp;<%=subject %></p>
				<p><i>Edition:</i>&nbsp;<%=edition %></p>
				<p><i>Publisher:</i>&nbsp;<%=publisher %></p>
				<p><i>Publication year:</i>&nbsp;<%=publication_year %></p>
			</div>
			<div id="foot">
				
					<%if(user==null){%>
					<h5 style="color:red">Please login to issue a book&nbsp;<a href="/Liberate" style="font-size:12px;">click</a></h5>
					<%} %>
					
				<%if(availability.equals("Available")&& user!=null&& !userType.equals("librarian")){%>
					<span style="float:left;background:yellow">Request for issue date:&nbsp;<%=issue_date %></span><br>
					<br><br>
				<form action="history" method="post">
				
					<input type="hidden" name="accession_no" value=<%=accession_no %> />
					<input type="hidden" name="mem_id" value=<%=user %> />
					<input type="hidden" name="mem_type" value=<%=userType %> />
					<input type="hidden" name="isbn" value=<%=isbn%> />
					<input type="hidden" name="req_for_issue_date" value=<%=issue_date %>>
					<input type="submit" value="ISSUE" class="btn" style="width:180px;" />
				</form>
					<%}%>
				
				<%if(availability.equals("Not Available")&& user!=null&& !userType.equals("librarian")){%>
					<span style="float:left">Reserve date:&nbsp;<%=issue_date %></span>
					<br>
				<form action="reserve" method="post">
				
					<input type="hidden" name="accession_no" value=<%=accession_no %> />
					<input type="hidden" name="mem_id" value=<%=user %> />
					<input type="hidden" name="mem_type" value=<%=userType %> />
					<input type="hidden" name="isbn" value=<%=isbn%> />
					<input type="hidden" name="reserve_date" value=<%=issue_date %>>
					<input type="submit" title="Please confirm another copy of this book is available or Not by clicking 'More Copies' button" value="RESERVE" class="btn" style="background:orange"/>
				</form>
					<%} %>
										
				
				
			</div>
		</div>
	</div>
	<div id="right">
		<%if(availability.equals("Available")){ %>
		<p><strong>Availability:</strong><span style="color:green"><%=availability %></span></p>
		<%} %>
		<%if(availability.equals("Not Available")){ %>
		<p><strong>Availability:</strong><span style="color:red"><%=availability %></span></p>
		<%} %>
		<p>ISBN:&nbsp;<%=isbn %></p>
		<form action="allcopies" method="post">
			<input type="hidden" name="isbn" value=<%=isbn %>>
			<input type="submit" title="See more copies of this book" value="More Copies" class="btn" style="width:100px"/>
		</form>
		
	
	</div>
	
	
</div>
<div id="footer">
<p style="text-align:center;color:white;">Copyright © All Rights Reserved 2017</p>

</div>
<script type="text/javascript">
<%if(status!=null){%>
	function fun() 
	{
		alert("<%=status%>");
	}
window.onload=fun;
<%}%>
</script>
</body>
</html>

