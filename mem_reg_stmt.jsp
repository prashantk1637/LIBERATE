<!--
******************************
This is password change page
******************************
-->
<%@page import="java.util.Date"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="statistics.Mem_reg_stmt_Bean"%>
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
	min-height:500px;
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
td{
padding: 7px;
}
table{
border-collapse: collapse;
width:98%;
margin:1%;
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
<%if(user==null) {%>
<% response.sendRedirect("/Liberate?error=login+first");%>
<%} 
else if(!userType.equals("librarian")) {%>
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
	<%if(userType==null){%>
	<li class="nav-item"><a href="catalog">Browse</a></li>
	<%} 
	else if(userType.equals("librarian")){%>
	<li class="nav-item"><a href="catalog">Browse</a></li>
	<%} 
	else if(userType.equals("student")|| userType.equals("teacher")){%>
	<li class="nav-item"><a href="bookCatalog">Browse</a></li>
	<%} %>
	<li class="nav-item" style="color:white">Welcome!&nbsp;&nbsp;<span style="color:orange"><b><%=user%></b></span></li>
	<%if(user!=null){%>
		<li class="nav-item"><a href="logout.jsp" style="color:red;"><b>Logout</b></a></li>
		<%}%>
	</ul>


</div>
<div id="container">
<%
	String start_date=request.getParameter("from");
	String end_date=request.getParameter("to");
	String sql="select email,name,issue_date from member";
	int flag=0;
	if(start_date==""&&end_date=="")
		 response.sendRedirect("librarian.jsp?mem_reg_stmt=Please choose atleast one of from Start date or end date");
	PreparedStatement pstmt;
	Connection con;
	SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
	 SimpleDateFormat df1 = new SimpleDateFormat("yyyy-MM-dd");
	 ArrayList<Mem_reg_stmt_Bean> mem_reg_list=new ArrayList<>();
	try {
		Class.forName("com.mysql.jdbc.Driver");
		con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");
		pstmt=(PreparedStatement) con.prepareStatement(sql);
		ResultSet rs=(ResultSet)pstmt.executeQuery();
		
	        
		while(rs.next())
		{	 Date date = df.parse(rs.getString(3));
		 	String reg_date_db=df1.format(date);
		 	if(end_date==""&&start_date!=null)
			{
				if(df1.parse(start_date).compareTo(df1.parse(reg_date_db))<=0)
				{
					Mem_reg_stmt_Bean obj=new Mem_reg_stmt_Bean();
					obj.setEmail(rs.getString(1));
					obj.setName(rs.getString(2));
					obj.setReg_date(rs.getString(3));
					mem_reg_list.add(obj);
				}
				
			}
		 	
		 	if(start_date==""&&end_date!=null)
			{
				if(df1.parse(end_date).compareTo(df1.parse(reg_date_db))>=0)
				{
					Mem_reg_stmt_Bean obj=new Mem_reg_stmt_Bean();
					obj.setEmail(rs.getString(1));
					obj.setName(rs.getString(2));
					obj.setReg_date(rs.getString(3));
					mem_reg_list.add(obj);
				}
				
					
			}
		 	
		 	if(start_date!="" && end_date!="")
			{
				if(df1.parse(start_date).compareTo(df1.parse(reg_date_db))<=0 &&df1.parse(end_date).compareTo(df1.parse(reg_date_db))>=0)
				{
					Mem_reg_stmt_Bean obj=new Mem_reg_stmt_Bean();
					obj.setEmail(rs.getString(1));
					obj.setName(rs.getString(2));
					obj.setReg_date(rs.getString(3));
					mem_reg_list.add(obj);
					
					
				}
				
				
			}
		 	
		 	
			
		}
		
	
	
	
	}catch(Exception e){}
	
%>
<h2>Member registration statement</h2>
<p>Showing result from 
<%if(start_date!=""){%>
<span style="color: red"><%=df.format(df1.parse(start_date))%></span>
<%} else {%>
<span style="color:red">START</span>
<%}%>
to
<%if(end_date!=""){%>
<span style="color: red"><%=df.format(df1.parse(end_date))%></span>
<%} else {%>
<span style="color:red">END</span>
<%}%>
</p>
<table border=1 style="text-align:center;background:white">
					<tr>
						<th>Member Id</th>
						<th>Name</th>
						<th>Registration Date</th>
					</tr>
<%for(Mem_reg_stmt_Bean o: mem_reg_list){ %>
<tr>
<td><%=o.getEmail() %></td>
<td><%=o.getName() %></td>
<td><%=o.getReg_date()%></td>
</tr>

<%} %>

</table>

</div>
</body>
</html>

