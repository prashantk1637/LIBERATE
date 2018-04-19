<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style type="text/css">
body{
margin:0;
padding:0;
background:silver;
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
innerborder:1px solid white

}
#nav ul li{
list-style:none;
float:left;
width:15%;
text-align:center;
}
#nav ul li a{
	color:white;
	font-size:17px;
}
#nav ul li a:hover{
	color:pink;
	font-size:18px;
	
}
a{
text-decoration:none;
font-size:20px;
}
</style>
</head>
<body>
<div id="header">
	<div id="logo"><img src="logo.png" alt="logo"/></div>
	<div id="banner"><img src="banner2.png" alt="image"/></div>
</div>

<div id="nav">
	<ul>
	<li class="nav-item"><a href="catalog">Browse</a></li>
	<li class="nav-item"><a href="search.jsp">Search</a></li>
	<li class="nav-item"><a href="#" >New Books</a></li>
	<li class="nav-item"><a href="#" >About LIBERATE</a></li>
	<li class="nav-item"><a href="#">Contact Us</a></li>
	</ul>


</div>
</body>
</html>