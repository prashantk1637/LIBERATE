<!--
******************************
This is Advanced search page
******************************
-->
<%@page import="recommendation.TagBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.mysql.jdbc.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="com.mysql.jdbc.PreparedStatement"%>
<%@page import="com.mysql.jdbc.Connection"%>
<html !DOCTYPE="html">
<head>
<title>LIBERATE</title>
<link rel="stylesheet" type="text/css" href="suggestion.css">
  <script src="suggestion-jquery.js"></script>
  <script src="suggestion-ui.js"></script>
 <link rel="stylesheet" type="text/css" href="header.css"/>
<style>
#container{
	
	width:100%;
	min-height:520px;
	background:#76D7C4;
	float:left;
}
#nav ul li a{
text-decoration:none;
font-size:20px;
}
.field{
width:180%;
height:30px;
border-radius:5px;
}
#advSearch{
margin-left:30%;
}
.btn{
height:30px;
width:100px;
border-radius: 3px;
cursor:pointer;
background-color: #4CAF50;
font-size:100%;
}
#tagCloud{
padding-left: 10px;
padding-right: 10px;
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
		String home="";
		String search_error=request.getParameter("search_error");
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
	<%if(userType==null){%>
	<li class="nav-item"><a href="bookcatalog.jsp">Browse</a></li>
	<%} 
	else if(userType.equals("librarian")){%>
	<li class="nav-item"><a href="bookcatalog.jsp">Browse</a></li>
	<%} 
	else if(userType.equals("student")|| userType.equals("teacher")){%>
	<li class="nav-item"><a href="bookCatalog">Browse</a></li>
	<%} %>
	<li class="nav-item"><a href="/Liberate/documentation/LIBERATEdoc.pdf" >About LIBERATE</a></li>
	<li class="nav-item"><a href="contact.html">Contact Us</a></li>
	<%if(user!=null){%>
		<li style="color:white" class="nav-item">Welcome!&nbsp;&nbsp;<span style="color:orange"><b><%=user%></b></span></li>	
	<%}%>
	<%if(user!=null){%>
		<li class="nav-item"><a href="logout.jsp" style="color:red;"><b>Logout</b></a></li>
		<%}%>
	</ul>


</div>
<%
				
				PreparedStatement pstmt=null;
				String sql="select tag,tag_type,count from tagcloud";
				ArrayList<TagBean> tag_list=new ArrayList<>();
				ArrayList<String> hint_list=new ArrayList<>();
				try{
					Class.forName("com.mysql.jdbc.Driver");  
					Connection con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
					pstmt=(PreparedStatement)con.prepareStatement(sql);
					ResultSet rs=(ResultSet)pstmt.executeQuery();
					
					while(rs.next())
					{
						TagBean obj=new TagBean();
						obj.setTag(rs.getString(1));
						obj.setTag_type(rs.getString(2));
						obj.setCount(rs.getInt(3));
						hint_list.add(rs.getString(1));
						tag_list.add(obj);
					}
					
				}catch(Exception e){ }
%>
<div id="container">
		<div id="advSearch">
				<h2>Advanced Search(For more Filtered result)</h2>
				<span>Note: <span style="color:red">At least one field is required</span></span><br>
				<span>(Fill more than one field for better result)</span>
				<form action="AdvanceSearch" method="get">
				<table>
					<tr>
						<td><input  id="search-input" class="field" type="text" name="title" placeholder=" Enter Title" autocomplete="off"/></td>
						</tr>
						<tr>
						<td><input class="field" type="text" name="author" placeholder="Enter Author"autocomplete="off" /></td>
						</tr>
						<tr>
						<td><input class="field" type="text" name="publisher" placeholder="Enter Publisher" autocomplete="off"/></td>
						</tr>
						<tr>
						<td><input class="field" type="number" name="publication_year" placeholder="Enter Publication year" autocomplete="off" min="1900"/></td>
						</tr>
						<tr>
						<td><input  title="You can enter multi-text keyword" class="field" type="text" name="keyword" placeholder="Enter some Keywords" autocomplete="off"/></td>
						
						</tr>
					
					<tr>
						<td><input type="submit" class="btn" value="Search"></td>
					</tr>
					<tr>
					<td></td><td></td><td><a href="search.jsp" style="color:black;font-size:18px;"><i>Standard Search...</i></a></td>
					<td></td><td></td><td><a href="isbnSearch.jsp" style="color:black;font-size:18px;"><i>ISBN Search...</i></a></td>
					
					</tr>
				</table>
				</form>
			</div>
			
			<h3 style="background:orange;text-align: center">Top Searches(Tags)</h3>
			<div id="tagCloud">
				
				<%
					int font=10;
					for(TagBean o: tag_list){ font=font+o.getCount();%>
					<%if(o.getCount()>3){ %>
					<a href="stdSearch?search_query=<%=o.getTag()%>&search_by=<%=o.getTag_type() %>" style="font-size:<%=font%>"><%=o.getTag() %></a>&nbsp;&nbsp;
						<%} %>
					<%font=10;} %>
				
				
				
			</div>
			
</div>

<script>
<%
if(search_error!=null)
{%>
 function search_errorFun()
 {
	 alert('<%=search_error%>');
}
window.onload=search_errorFun;
<%}%>

$( function() {
	  var i=0;
	  var arr=[];
	  <%for (String str: hint_list) { %>
	  		arr.push('<%=str%>');
	  <% } %>

  $( ".field" ).autocomplete({
    source: arr
  });
} );
</script>
</body>
</html>
