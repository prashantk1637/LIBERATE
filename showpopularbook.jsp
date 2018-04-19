<!--
******************************
This page shows popular books
******************************
-->
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
td{
padding: 10px;
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
<% if(!userType.equals("librarian")) {%>
 <%response.sendRedirect("error.jsp");%>
<%}%>
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
	<li class="nav-item"><a href="catalog">Browse</a></li>
	<li class="nav-item"><a href="search.jsp">Search books</a></li>
	<%if(user!=null){%>
		<li class="nav-item" style="color:white">Welcome!&nbsp;&nbsp;<span style="color:orange"><b><%=user%></b></span></li>
		
	<%}%>
	<%if(user!=null){%>
		<li class="nav-item"><a href="logout.jsp" style="color:red;"><b>Logout</b></a></li>
		<%}%>
	</ul>


</div>
<div id="container">

<%
if(user==null)
	response.sendRedirect("/Liberate?error=Login+first");

String sql="select isbn, count(*) as count from issue where issue_approval=? group by isbn order by count desc";
PreparedStatement pstmt;
Connection con;
ArrayList<PopularBookBean>list=new ArrayList<>();
try {
	Class.forName("com.mysql.jdbc.Driver");
	con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");
	pstmt=(PreparedStatement) con.prepareStatement(sql);
	pstmt.setString(1, "issued");
	ResultSet rs=(ResultSet)pstmt.executeQuery();
	
	while(rs.next())
	{
		sql="select path,title,author,edition,publication_year,count(*) from books where isbn=? group by isbn";
		pstmt=(PreparedStatement) con.prepareStatement(sql);
		pstmt.setString(1, rs.getString(1));
		ResultSet rs1=(ResultSet)pstmt.executeQuery();
		if(rs1.next())
		{	PopularBookBean obj=new PopularBookBean();
			obj.setPath(rs1.getString(1));
			obj.setTitle(rs1.getString(2));
			obj.setAuthor(rs1.getString(3));
			obj.setEdition(rs1.getString(4));
			obj.setPublication_year(rs1.getInt(5));
			obj.setIsbn(rs.getString(1));
			obj.setNo_issued_copy(rs.getInt(2));
			obj.setNo_of_remaining_copy(rs1.getInt(6)-rs.getInt(2));
			sql="select count(*) from reserve where isbn=? group by isbn";
			pstmt=(PreparedStatement) con.prepareStatement(sql);
			pstmt.setString(1, rs.getString(1));
			ResultSet rs2=(ResultSet)pstmt.executeQuery();
			if(rs2.next())
				obj.setNo_reserved_copy(rs2.getInt(1));
			// No of reservation is higher than no of available copies then book
			// will be said in demand
			if(obj.getNo_reserved_copy()>obj.getNo_of_remaining_copy())
				list.add(obj);
		}
		
	}
	// sort list based on remaining copies
	if (list.size() > 1) {
		  Collections.sort(list, new Comparator<PopularBookBean>() {
		      @Override
		      public int compare(final PopularBookBean object1, final PopularBookBean object2) {
		          return Integer.valueOf(object1.getNo_reserved_copy()).compareTo(Integer.valueOf(object2.getNo_reserved_copy()));
		      }
		  });
		}
		
 }catch(Exception e){}
%>

<table border=1 style="text-align:center;background:white">
<tr>
<th>Title</th>
<th>Author</th>
<th>ISBN</th>
<th>Edition</th>
<th>Publication Year</th>
<th>No of Issued Copy</th>
<th>No of Reservation</th>
<th>No of available Copy</th>

</tr>
<%
for(int i=list.size()-1;i>=0;i--){
PopularBookBean o=list.get(i);
%>	
<tr>
<td><%=o.getTitle() %></td>
<td><%=o.getAuthor() %></td>
<td><%=o.getIsbn() %></td>
<td><%=o.getEdition() %></td>
<td><%=o.getPublication_year() %></td>
<td><%=o.getNo_issued_copy() %></td>
<td><%=o.getNo_reserved_copy() %></td>
<td><%=o.getNo_of_remaining_copy()%></td>
</tr>
<%}%>
</table>
</div>
</body>
</html>

