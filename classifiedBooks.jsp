<!--
******************************
shows list of books available in
library database 
******************************
-->
<%@page import="java.util.*"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.liberate.*" %>
<html !DOCTYPE="html">
<head>
<title>LIBERATE</title>
<link rel="stylesheet" type="text/css" href="header.css"/>
<style>
#container{
	
	width:90%;
	min-height:500px;
	background:white;
	float:left;
	padding-left:10%;
}
.item{
width:250px;
height:150px;
float:left;
padding-left:10px;
padding-top:20px;
padding-bottom:20px;
background:#76D7C4;
margin-top: 20px;
border:2px solid white;
}
.item:hover{
box-shadow:0px 0px 15px;
position:relative;
z-index:50px;
}
.item a{
text-decoration:none;
}
.item .book-img{
	width:100px;
	height:150px;
	float:left;
	box-sizing: border-box;
	border: 2px solid silver;
}
.item .book-img img
{	width:100%;
	height:100%;
	background-image: url('/Liberate/books/no_preview.png');
}
.item .book-desc{
height:100%;
width:50%;
padding-left:5px;
float:left;
}
.item .book-desc p{
font-size:16px;
color:black;

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
	String userType="nouser";
	userType=(String)s.getAttribute("userType");
	Object obj=request.getAttribute("LIST");
	ArrayList<BookDetailsBean> bookList=(ArrayList<BookDetailsBean>)obj;
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
	<li class="nav-item"><a href=<%=home %>>Home</a></li>
	<%} %>
	<li class="nav-item"><a href="search.jsp"onclick="#">Search</a></li>
	<li class="nav-item"><a href="#" onclick="#">LIBERATE</a></li>
	<li class="nav-item"><a href="#" onclick="#">Contact Us</a></li>
	<%if(user!=null){%>
		<li class="nav-item" style="color:white">Welcome!&nbsp;&nbsp;<span style="color:orange"><b><%=user%></b></span></li>
	<%} %>
	<%if(user!=null){%>
		<li class="nav-item"><a href="logout.jsp" style="color:red;"><b>Logout</b></a></li>
		<%}%>
	</ul>
</div>

<div id="container">
	<a href="/Liberate/classifiedBooks.jsp">Classify Books</a>
	<%for(BookDetailsBean o:bookList){
		int accession_no=o.getAccession_no();
		String path=o.getPath();
		String title=o.getTitle();
		String author=o.getAuthor();
		String edition=o.getEdition();%>
		<a href="issue?access=<%=accession_no%>">
		<div class="item">
				
			<div class="book-img"><img src=<%=path %> alt="image" /></div>
			<div class="book-desc">
				<p><span><b><%=title %></b></span><br></br>
				<span><i style="color:brown"><%=author %></i></span>
				
				</p>
			</div>
	
		</div>
	</a>
	
	<%} %>	
</div>
</body>

</html>

