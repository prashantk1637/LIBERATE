<!--
************************************************
This page shows rare issued books for promotion
*************************************************
-->
<%@page import="recommendation.RarelyIssuedBookBean"%>
<%@page import="java.util.*"%>
<%@page import="recommendation.PopularBookBean"%>
<%@page import="recommendation.PopularBooks"%>
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
table{
border-collapse: collapse;
width:98%;
margin-top:1%;
margin-left: 1%;
margin-right: 1%;
}
td img{
width:80px;
height:100px;
background-image: url('/Liberate/books/no_preview.png')
}
</style>

</head>

<body>
<%
		HttpSession s=request.getSession(false);
		String user=(String)s.getAttribute("user");
		String userType="";
		userType=(String)s.getAttribute("userType");
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
	<% if(user!=null&&(userType.equals("student")|| userType.equals("teacher"))){%>
	<li class="nav-item"><a href="bookCatalog">Browse</a></li>
	<%} else{%>
		<li class="nav-item"><a href="bookcatalog.jsp">Browse</a></li>
	<%} %>
	<li class="nav-item"><a href="search.jsp">Search books</a></li>
	<%if(user!=null){%>
		<li class="nav-item" style="color:white">Welcome!&nbsp;&nbsp;<span style="color:orange"><b><%=user%></b></span></li>
		
	<%}%>
	<%if(user!=null){%>
		<li class="nav-item"><a href="logout.jsp" style="color:red;"><b>Logout</b></a></li>
		<%}%>
	</ul>


</div>


<%
String sql="select path,title,author,edition,publication_year,count(*), publisher,isbn from books group by isbn";
PreparedStatement pstmt;
Connection con;
ArrayList<RarelyIssuedBookBean>list=new ArrayList<>();
try {
	Class.forName("com.mysql.jdbc.Driver");
	con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");
	pstmt=(PreparedStatement) con.prepareStatement(sql);
	
	ResultSet rs=(ResultSet)pstmt.executeQuery();
	
	while(rs.next())
	{
		RarelyIssuedBookBean obj=new RarelyIssuedBookBean();
		obj.setPath(rs.getString(1));
		obj.setTitle(rs.getString(2));
		obj.setAuthor(rs.getString(3));
		obj.setEdition(rs.getString(4));
		obj.setPublication_year(rs.getInt(5));
		obj.setTotal_copy(rs.getInt(6));
		obj.setPublisher(rs.getString(7));
		obj.setIsbn(rs.getString(8));
		
		sql="select count(*) from issue_log where isbn=? group by isbn";
		pstmt=(PreparedStatement) con.prepareStatement(sql);
		pstmt.setString(1, rs.getString(8));
		ResultSet rs1=(ResultSet)pstmt.executeQuery();
		if(rs1.next())
		{	
			obj.setNo_issued_copy(rs1.getInt(1));
		}else obj.setNo_issued_copy(0);
			
			
			double fraction=(1.0*obj.getNo_issued_copy()/obj.getTotal_copy());
			obj.setIssue_by_total_fraction(fraction);
			list.add(obj);
			
			
	}
		
	
	// sort list based on remaining copies
	if (list.size() > 1) {
		  Collections.sort(list, new Comparator<RarelyIssuedBookBean>() {
		      @Override
		      public int compare(final RarelyIssuedBookBean object1, final RarelyIssuedBookBean object2) {
		          return Double.valueOf(object1.getIssue_by_total_fraction()).compareTo(Double.valueOf(object2.getIssue_by_total_fraction()));
		      }
		  });
		}
		
 }catch(Exception e){}
%>
<span style="font-size: 25px;">Rarely Issued But Useful book</span>
<div id="container">

<table border=1 style="text-align:center;background:white">
<tr>
<th>Book View</th>
<th>Title</th>
<th>Author</th>
<th>ISBN</th>
<th>Edition</th>
<th>Publisher</th>
<th>Publication Year</th>
<th>Total copy</th>
<th>No of issued copy</th>
<th>Fraction(Issue/Total)</th>

</tr>
<%
for(int i=0;i<list.size();i++){
RarelyIssuedBookBean o=list.get(i);
%>	
<tr>
<td><img alt="book" src="<%=o.getPath()%>"></td>
<td><%=o.getTitle() %></td>
<td><%=o.getAuthor() %></td>
<td><%=o.getIsbn() %></td>
<td><%=o.getEdition()%></td>
<td><%=o.getPublisher()%></td>
<td><%=o.getPublication_year()%></td>
<td><%=o.getTotal_copy()%></td>
<td><%=o.getNo_issued_copy()%></td>
<td><%=o.getIssue_by_total_fraction()%></td>


</tr>
<%}%>
</table>
</div>
</body>
</html>

