<!--
******************************
Search result page
******************************
-->
<%@page import="java.util.*"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.liberate.*" %>
<html !DOCTYPE="html">
<head>
<title>LIBERATE</title>
<style>
body{
margin:0;
padding:0;
background:white;
}
#header{
height:130px;
width:100%;
background:yellow;
float:left;
}
#header #logo{
	width:20%;
	height:130px;
	background:#A3E4D7;
	float:left;
}
img{
	width:100%;
	height:100%;
}
#header #banner{
	width:80%;
	height:130px;
	float:left;
}
#nav{
min-height:40px;
width:100%;
background:#2471A3;
float:left;
padding-bottom:7px;

}
.nav-item{
list-style:none;
float:left;
margin-left:10%;
}
.nav-item a{
	
	color:white;
	text-decoration:none;
}
.nav-item a:hover{
	color:pink
}
.container{
	
	width:95%;
	min-height:50px;
	background:white;
	float:left;
	padding-left:5%;
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

</style>
</head>

<body>
<%
	HttpSession s=request.getSession(false);
	String user=(String)s.getAttribute("user");
	String userType="nouser";
	userType=(String)s.getAttribute("userType");
	Object obj=request.getAttribute("MAIN_LIST");
	Object obj1=request.getAttribute("RELEVANT_LIST");
	ArrayList<BookDetailsBean> bookList=(ArrayList<BookDetailsBean>)obj;
	ArrayList<BookDetailsBean> relevant_bookList=(ArrayList<BookDetailsBean>)obj1;
	String home="";
	int flag=0;
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
	<li class="nav-item"><a href="search.jsp"onclick="#">Book Search</a></li>
	<li class="nav-item"><a href="#" onclick="#">LIBERATE</a></li>
	<li class="nav-item"><a href="#" onclick="#">Contact Us</a></li>
	<li class="nav-item" style="color:orange;">
	<%if(user!=null){%>
		<%=user%>
		
	<%}%></li>
	<%if(user!=null){%>
		<li class="nav-item"><a href="logout.jsp" style="color:red;"><b>Logout</b></a></li>
		<%}%>
	</ul>
</div>


<div style="font-size:25px;background:silver;width:100%"><i>Your Search Result</i></div>
<div class="container">
<%if(bookList.size()!=0){ %>
	<%for(BookDetailsBean o:bookList){
		flag=1;
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

	<%} else{ %>
<h3>your choice not found</h3>
<%} %>
</div>
<%if(relevant_bookList.size()!=0){ %>
<div style="font-size:25px;background:silver;width:100%"><i>Relevant Search result</i></div>
<div class="container">
	
	
	<%for(BookDetailsBean o:relevant_bookList){
		flag=1;
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
<%} %>


</body>

</html>

