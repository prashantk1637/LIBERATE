<!--
******************************
This is standard search page
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
#isbnSearch{
margin-left:30%;
min-height: 200px;
}
.btn{
height:30px;
width:100px;
border-radius: 3px;
cursor:pointer;
background-color: #4CAF50;
font-size:100%;
}
#tagCloud
{
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
						tag_list.add(obj);
					}
					sql="select isbn_no from stdsearch";
					pstmt=(PreparedStatement)con.prepareStatement(sql);
					rs=(ResultSet)pstmt.executeQuery();
					
					while(rs.next())
					{
						hint_list.add(rs.getString(1));
					
					}
					
				}catch(Exception e){ }
%>
<div id="container">
		<div id="isbnSearch">
				<h2>ISBN&nbsp;Search</h2>
				<form action="isbnSearch">
				<table>
					<tr>
						<td><input class="field" id="search-input" type="text" name="isbn" placeholder="Enter book ISBN..." required autocomplete="off"/></td>
					
					</tr>
					
					<tr>
						<td><input type="submit" class="btn" value="Search"></td>
					
					</tr>
					 <tr>
					 <td></td><td></td><td><a href="search.jsp" style="color:black;font-size:18px;"><i>Standard Search...</i></a></td>
					<td></td><td></td><td><a href="advanceSearch.jsp" style="color:black;font-size:18px;"><i>Advanced Search...</i></a></td>
					 
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
  $( function() {
	  var i=0;
	  var arr=[];
	  <%for (String str: hint_list) { %>
	  		arr.push('<%=str%>');
	  <% } %>
  
    $( "#search-input" ).autocomplete({
      source: arr
    });
  } );
  </script>

</body>
</html>

