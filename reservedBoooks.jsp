<%@page import="com.liberate.ReservedBookBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.liberate.IssuedBookedDetailsBean"%>
<%@page import="com.mysql.jdbc.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="com.mysql.jdbc.PreparedStatement"%>
<%@page import="com.mysql.jdbc.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="header.css"/>
<style type="text/css">
a{
text-decoration:none;
font-size:20px;
}
table{
border-collapse: collapse;
}
.key{
background:silver;
height:40px;
text-align: center;
font-weight: bold;
width: 200px;

}
.value
{
background:skyblue;
height:40px;
text-align: center;
width: 800px;
}
table{
width:100%;
}
</style>
</head>
<body>
<%

	HttpSession s=request.getSession(false);
	String user=(String)s.getAttribute("user");
%>
<%if(user==null) {%>
<% response.sendRedirect("/Liberate?error=login+first");%>
<%} %>
<div id="header">
	<div id="logo"><img src="logo.png" alt="logo"/></div>
	<div id="banner"><img src="banner2.png" alt="image"/></div>
</div>

<div id="nav">
	<ul>
	<li class="nav-item" style="color:orange"><a href="member.jsp">home</a></li>
	<li class="nav-item"><a href="issuedDetails">Issue Book Status</a></li>
	<li class="nav-item"><a href="returnStatus">Return Books Status</a></li>
	<li class="nav-item" style="color:orange"><%=user%></li>
	<li class="nav-item"><a href="logout.jsp" style="color:red;"><b>Logout</b></a></li>
	</ul>


</div>
<%
		int accession_no;
		String flag=null;
		if(user==null)
			response.sendRedirect("/Liberate?error=Login+first");
		PreparedStatement pstmt=null,pstmt1=null,pstmt2=null;	
		String sql="select * from reserve where mem_id=?";
		String sql1="select title from books where accession_no=?";
		String sql2="select return_date, issue_approval from issue where accession_no=?";
		ArrayList<ReservedBookBean> list=new ArrayList<>();
		try{
				Class.forName("com.mysql.jdbc.Driver");  
				Connection con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
				pstmt=(PreparedStatement)con.prepareStatement(sql);
				pstmt1=(PreparedStatement)con.prepareStatement(sql1);
				pstmt2=(PreparedStatement)con.prepareStatement(sql2);
				pstmt.setString(1,user);
				ResultSet rs=(ResultSet) pstmt.executeQuery();
				
				while(rs.next())
				{	ReservedBookBean obj=new ReservedBookBean();
					obj.setAccession_no(rs.getInt(1));
					obj.setMem_id(rs.getString(2));
					obj.setMem_type(rs.getString(3));
					obj.setIsbn(rs.getString(4));
					obj.setReserved_date(rs.getString(5));
					flag=rs.getString(6);
					pstmt1.setInt(1, rs.getInt(1));
					ResultSet rs1=(ResultSet)pstmt1.executeQuery();
					if(rs1.next())
						obj.setTitle(rs1.getString(1));
					pstmt2.setInt(1, rs.getInt(1));
					ResultSet rs2=(ResultSet)pstmt2.executeQuery();
					if(rs2.next())
					{
						
						if(rs2.getString(2).equals("issued")&&flag==null)
						{
							obj.setReturn_date(rs2.getString(1));
							obj.setBook_status("Issued by someone");
						}
						else
						{
							if(flag!=null)
							{
								obj.setReturn_date("N/A");
								obj.setBook_status(flag);	
							}
							else{
							obj.setReturn_date("N/A");
							obj.setBook_status("Issued by someone");
							}
						}
						
					}
					
					list.add(obj);
				}
			
		}catch(Exception e){}
%>
<span style="font-size: 30px;">Reserved books</span>
<div id="container">
		<table border=1 style="text-align:center;background:white">
					<tr>
						<th>Accession No.</th>
						<th>Title</th>
						<th>Reserved By</th>
						<th>Reserve Date</th>
						<th>Member type</th>
						<th>ISBN</th>
						<td>Book Status</td>
						<td>Due date</td>
						<th>Action</th>
					</tr>
		<% for(ReservedBookBean o: list){%>
			<%
			
				accession_no=o.getAccession_no();
				String title=o.getTitle();
				String mem_id=o.getMem_id();
				String mem_type=o.getMem_type();
				String isbn=o.getIsbn();
				String reserve_date=o.getReserved_date(); 
				String return_date=o.getReturn_date();//Reaturing b someone else who have issued book
				String book_status=o.getBook_status();
				%>
				
				<tr>
					<td><%=accession_no %></td>
					<td><%=title %></td>
					<td><%=mem_id %></td>
					<td><%=reserve_date%></td>
					<td><%=mem_type%></td>
					<td><%=isbn %></td>
						<%if(!book_status.equals("Issued by someone")){%>
					<td style="color:green;width:200px;"><marquee><%=book_status %></marquee></td>
					<%}else {%>
					<td><%=book_status %></td>
					<%} %>
					<td><%=return_date %></td>
					
					
					<td>
						<form action="bookRelease.jsp">
							<input type="hidden" name="accession_no" value=<%=accession_no%> />
							<input type="submit" value="Release" />
						
						
						</form>
					
					</td>
				
				</tr>
				
					
				
				
		<%} %>
		</table>
</div>

</body>
</html>