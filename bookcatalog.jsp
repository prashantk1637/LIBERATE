<!--
******************************
This is book listing page
******************************
-->
<%@page import="recommendation.ClassificationBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.liberate.BookDetailsBean"%>
<%@page import="com.mysql.jdbc.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="com.mysql.jdbc.Connection"%>
<%@page import="com.mysql.jdbc.PreparedStatement"%>
<html !DOCTYPE="html">
<head>
<title>LIBERATE</title>
 <link rel="stylesheet" type="text/css" href="header.css"/>
<style>
.container{
	
	width:90%;
	min-height:100px;
	background:white;
	float:left;
	padding-left:10%;
	padding-bottom: 10px;
}
.heading{
margin-right:13%;
background: silver;
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
#quick-link{
margin-left:80%;
top:150px;
position: fixed;
background: orange;
padding: 4px;
}
#footer{
	
	width:100%;
	height:100px;
	background:black;
	float:left;
	margin-top: 30px;
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
	<li class="nav-item"><a href=<%=home %>>Home</a></li>
	<%} %>
	<li class="nav-item"><a href="search.jsp"onclick="#">Book Search</a></li>
	<li class="nav-item"><a href="/Liberate/documentation/LIBERATEdoc.pdf" >About LIBERATE</a></li>
	<li class="nav-item"><a href="contact.html">Contact Us</a></li>
	<%if(user!=null){%>
		<li class="nav-item" style="color:white">Welcome!&nbsp;&nbsp;<span style="color:orange"><b><%=user%></b></span></li>
	<%} %>
	<%if(user!=null){%>
		<li class="nav-item"><a href="logout.jsp" style="color:red;"><b>Logout</b></a></li>
		<%}%>
	</ul>
</div>
<%
PreparedStatement pstmt;
String sql="select isbn,tag from book_tag";
ArrayList<ClassificationBean> list=new ArrayList<>();
ArrayList<BookDetailsBean> cse_list=new ArrayList<>();
ArrayList<BookDetailsBean> ece_list=new ArrayList<>();
ArrayList<BookDetailsBean> me_list=new ArrayList<>();
ArrayList<BookDetailsBean> math_list=new ArrayList<>();
try{
		Class.forName("com.mysql.jdbc.Driver");  
		Connection con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
		pstmt=(PreparedStatement) con.prepareStatement(sql);
		ResultSet rs=(ResultSet)pstmt.executeQuery();
		while(rs.next())
		{
			String isbn=rs.getString(1);
			String[] strArr=rs.getString(2).split(":");
			String tag=strArr[0];
			ClassificationBean obj=new ClassificationBean();
					obj.setIsbn(isbn);
					obj.setTag(tag);
					list.add(obj);
			
		}
		
		sql="select accession_no,path,title,author from books where isbn=?";
		pstmt=(PreparedStatement) con.prepareStatement(sql);
		for(ClassificationBean o: list)
		{
			if(o.getTag().equals("cse") || o.getTag().equals("it"))
			{
				pstmt.setString(1, o.getIsbn());
				rs=(ResultSet)pstmt.executeQuery();
				if(rs.next())
				{
					BookDetailsBean obj=new BookDetailsBean();
					obj.setAccession_no(rs.getInt(1));
					obj.setPath(rs.getString(2));
					obj.setTitle(rs.getString(3));
					obj.setAuthor(rs.getString(4));
					cse_list.add(obj);
				}
					
			}
			if(o.getTag().equals("ece"))
			{
				pstmt.setString(1, o.getIsbn());
				rs=(ResultSet)pstmt.executeQuery();
				if(rs.next())
				{
					BookDetailsBean obj=new BookDetailsBean();
					obj.setAccession_no(rs.getInt(1));
					obj.setPath(rs.getString(2));
					obj.setTitle(rs.getString(3));
					obj.setAuthor(rs.getString(4));
					ece_list.add(obj);
				}
					
			}
			if(o.getTag().equals("me"))
			{
				pstmt.setString(1, o.getIsbn());
				rs=(ResultSet)pstmt.executeQuery();
				if(rs.next())
				{
					BookDetailsBean obj=new BookDetailsBean();
					obj.setAccession_no(rs.getInt(1));
					obj.setPath(rs.getString(2));
					obj.setTitle(rs.getString(3));
					obj.setAuthor(rs.getString(4));
					me_list.add(obj);
				}
					
			}
			if(o.getTag().equals("math"))
			{
				pstmt.setString(1, o.getIsbn());
				rs=(ResultSet)pstmt.executeQuery();
				if(rs.next())
				{
					BookDetailsBean obj=new BookDetailsBean();
					obj.setAccession_no(rs.getInt(1));
					obj.setPath(rs.getString(2));
					obj.setTitle(rs.getString(3));
					obj.setAuthor(rs.getString(4));
					math_list.add(obj);
				}
					
			}
			
		}
}catch (Exception e) {}
%>
<div class="container">
	<span id="quick-link">GO TO
	<a href="#cse">CSE/IT</a>
	<a href="#ece">ECE</a>
	<a href="#me">ME</a>
	<a href="#math">MATH</a>
	</span>
	<h3 class="heading" id="cse" >Computer Science books(CSE/IT)</h3>
	<%for(BookDetailsBean o:cse_list){
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
<div class="container">
	<h3 class="heading"  id="ece">Electronics and Communication</h3>
	<%for(BookDetailsBean o:ece_list){
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
<div class="container">
	<h3 class="heading" id="me" >Mechanical Engineering</h3>
	<%for(BookDetailsBean o:me_list){
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
<div class="container">
	<h3 class="heading" id="math">Mathematics</h3>
	<%for(BookDetailsBean o:math_list){
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

