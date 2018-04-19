<%@page import="java.util.HashSet"%>
<%@page import="com.liberate.AllPaymemtsBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.liberate.AllPayments"%>
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
font-size: 20px;
}
#container{
	
	width:100%;
	min-height:500px;
	background:#76D7C4;
	float:left;
}
#left{
float: left;
width:70%;
height:500px;

}
#right{
float: left;
width:30%;
height:500px;
display: none;

}
table{
width:90%;
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
background:white;
height:40px;
text-align: center;
width: 600px;
}
.btn{
height:25px;
width:80px;
border-radius: 2px;
background:green;
cursor:pointer;
color:white;
padding: 2px;
}
.btn:hover
{
box-shadow:2px 2px 10px red;
}
</style>
</head>
<body>
<%

	HttpSession s=request.getSession(false);
	String user=(String)s.getAttribute("user");
	String userType=(String)s.getAttribute("userType");
	String passchanged=(String)request.getAttribute("passchanged");
%>
<%if(user==null) {%>
<% response.sendRedirect("/Liberate?error=login+first");%>
<%} 
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
	<li class="nav-item" style="color:orange"><a href="<%=home%>">home</a></li>
	<li class="nav-item"><a href="issuedDetails">Issue Status</a></li>
	<li class="nav-item"><a href="returnStatus">Return Status</a></li>
	<li style="color:white" class="nav-item">Welcome!&nbsp;&nbsp;<span style="color:orange"><b><%=user%></b></span></li>
	<li class="nav-item"><a href="logout.jsp" style="color:red;"><b>Logout</b></a></li>
	</ul>


</div>
<%
		String username=null,password=null,name=null,dob=null,gender=null,address=null,mem_type=null,mem_reg_date=null,mem_expiry_date=null;
		int fee_deposit=0;
		PreparedStatement pstmt=null;
		Connection con=null;
		String sql="select * from member where email=?";
		String sql1="select amount from payment where mem_id=?";
		int amt=0,total_fee=0;
		try{
				Class.forName("com.mysql.jdbc.Driver");  
				con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
				pstmt=(PreparedStatement) con.prepareStatement(sql);
				pstmt.setString(1,user);
				ResultSet rs=(ResultSet) pstmt.executeQuery();
				if(rs.next())
				{
					username=rs.getString(1);
					password=rs.getString(2);
					name=rs.getString(3);
					dob =rs.getString(4);
					gender=rs.getString(5);
					address=rs.getString(6);
					mem_type=rs.getString(7);
					mem_reg_date=rs.getString(8);
					mem_expiry_date=rs.getString(9);
					fee_deposit=rs.getInt(10);
				}
				pstmt=(PreparedStatement) con.prepareStatement(sql1);
			
					pstmt.setString(1,username);
					rs=(ResultSet) pstmt.executeQuery();
					
					while(rs.next())
					{
						amt=amt+rs.getInt(1);
					}
			total_fee=fee_deposit+amt;
		}catch(Exception e){}
			
%>
<%
//calculating item similarity
sql1="select mem_id2 from usersimilarity where mem_id1=? and mem_id2!=? and similarity>?";
PreparedStatement pstmt1=(PreparedStatement)con.prepareStatement(sql1);
pstmt1.setString(1, user);
pstmt1.setString(2, user);
pstmt1.setFloat(3, 0.5f);
ResultSet rs1=(ResultSet) pstmt1.executeQuery();
String tag="";
String new_tag="";
HashSet<String> tag_set=new HashSet<>();
while(rs1.next())
{
	sql="select interest from userinterest where email=?";
	pstmt=(PreparedStatement)con.prepareStatement(sql);
	pstmt.setString(1, rs1.getString(1));
	ResultSet rs=(ResultSet)pstmt.executeQuery();
	while(rs.next())
	{
		new_tag=new_tag+rs.getString(1);
	}
	
}
sql="select interest from userinterest where email=?";
pstmt=(PreparedStatement)con.prepareStatement(sql);
pstmt.setString(1, user);
ResultSet rs=(ResultSet)pstmt.executeQuery();
if(rs.next())
{
	tag=rs.getString(1);
}
tag=tag+new_tag;
String tags[]=tag.split(":");
for(String str: tags)
	tag_set.add(str);
String updated_tag="";
for(String str: tag_set)
	updated_tag=updated_tag+str+":";
sql="update userinterest set interest=? where email=?";
pstmt=(PreparedStatement)con.prepareStatement(sql);
pstmt.setString(1,updated_tag);
pstmt.setString(2,user);
pstmt.executeUpdate();




%>
<div id="container">
<div id="left">
<span style="font-size: 20px;color:green;">Your Details</span>
<table border=1>
	<tr>
		<td class="key">Username(Email)</td><td class="value"><%=username%></td>
	</tr>
	<tr>
		<td class="key">Password</td><td class="value"><input id="pass" type="password" value=<%=password %> disabled="disabled">
		<a href="changepass.jsp" class="btn" >Change Password</a>
		</td>
	</tr>
	<tr>
		<td class="key">Full Name</td><td class="value"><%=name%></td>
	</tr>
	<tr>
		<td class="key">Date of Birth</td><td class="value"><%=dob%></td>
	</tr>
	<tr>
		<td class="key">Gender</td><td class="value"><%=gender%></td>
	</tr>
	<tr>
		<td class="key">Address</td><td class="value"><%=address%></td>
	</tr>
	<tr>
		<td class="key">Type of Member</td><td class="value"><%=mem_type%></td>
	</tr>
	<tr>
		<td class="key">Date of Registration</td><td class="value"><%=mem_reg_date%></td>
	</tr>
	<tr>
		<td class="key">Date of Renewal</td><td class="value"><%=mem_expiry_date%></td>
	</tr>
	<tr>
		<td class="key">Total fee deposit</td><td class="value">Rs.<%=total_fee%><a href="#" onclick="fun()" style="margin-left:10px;">View all Payments details</a></td>
	</tr>

</table>
</div>


<div id="right">
<%
AllPayments obj=new AllPayments();
ArrayList<AllPaymemtsBean> payment_list=obj.getAllPayemt(username);
 
%>
<span style="font-size: 20px;color:green;">All Payments</span>
<table border=1 style="text-align:center;background:white">
					<tr>
						<th>Amount</th>
						<th>Payment Date</th>
					</tr>
<tr>
<td><%=fee_deposit %></td>
<td><%=mem_reg_date %></td>
</tr>
<%for(AllPaymemtsBean o: payment_list) {%>
<tr>
<td><%=o.getAmount()%></td>
<td><%=o.getPaymemt_date() %></td>
</tr>
<%} %>
</table>

</div>

</div>
<script>
<%if(passchanged!=null) { %>
alert("<%=passchanged%>");

<%}%>
function fun()
{
	document.getElementById("right").style.display="block";
}

</script>
</body>
</html>