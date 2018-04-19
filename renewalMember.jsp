<!--
******************************
This is password change page
******************************
-->
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
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
	background:skyblue;
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
table{
width:100%;
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
</style>

</head>

<body>
<%
		HttpSession s=request.getSession(false);
		String user=(String)s.getAttribute("user");
		String userType=(String)s.getAttribute("userType");
		String mem_id1=(String)request.getAttribute("mem_id");
		String payment_status=(String)request.getAttribute("payment_status");
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
<%if(user==null) {%>
<% response.sendRedirect("/Liberate?error=login+first");%>
<%} 
else if(!userType.equals("librarian")) {%>
 <%response.sendRedirect("error.jsp");%>
<%}%>
<div id="nav">
	<ul>
	<%if(user!=null){%>
	<li class="nav-item"><a href=<%=home %> title="home page" onclick="home()">Home</a></li>
	<%} %>
	<li class="nav-item"><a href="catalog"title="book browse" >Browse</a></li>
	<li class="nav-item"><a href="search.jsp" title="Book Search">Book Search</a></li>
	<li class="nav-item" style="color:white">Welcome!&nbsp;&nbsp;<span style="color:orange"><b><%=user%></b></span></li>
	<%if(user!=null){%>
		<li class="nav-item"><a href="logout.jsp" style="color:red;"><b>Logout</b></a></li>
		<%}%>
	</ul>


</div>
<%
String mem_id=null,password=null,name=null,dob=null,gender=null,address=null,mem_type=null,mem_reg_date=null,today=null,mem_due_renewal_date=null;
int fee_deposit=0,refund=0;
long days=0;
mem_id=request.getParameter("mem_id");
PreparedStatement pstmt=null;	
mem_id=request.getParameter("mem_id");
String sql1="select amount from payment where mem_id=?";
String sql2="select * from member where email=?";
int amt=0;

try{
		Class.forName("com.mysql.jdbc.Driver");  
		Connection con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
		pstmt=(PreparedStatement) con.prepareStatement(sql1);
		if(mem_id!=null)
			pstmt.setString(1,mem_id);
		else if(mem_id1!=null)
			pstmt.setString(1,mem_id1);
			ResultSet rs=(ResultSet) pstmt.executeQuery();
			
			while(rs.next())
			{
				amt=amt+rs.getInt(1);
			}
			
			pstmt=(PreparedStatement) con.prepareStatement(sql2);
			if(mem_id!=null)
				pstmt.setString(1,mem_id);
			else if(mem_id1!=null)
				pstmt.setString(1,mem_id1);
				rs=(ResultSet) pstmt.executeQuery();
			
		if(rs.next())
		{
			mem_id=rs.getString(1);
			password=rs.getString(2);
			name=rs.getString(3);
			dob =rs.getString(4);
			gender=rs.getString(5);
			address=rs.getString(6);
			mem_type=rs.getString(7);
			mem_reg_date=rs.getString(8);
			mem_due_renewal_date=rs.getString(9);
			fee_deposit=rs.getInt(10);
			fee_deposit=fee_deposit+amt;
			DateFormat df=new SimpleDateFormat("dd/MM/yyyy");
			Date d=new Date();
			today=df.format(d);
			Date d1 = new SimpleDateFormat("dd/MM/yyyy").parse(mem_reg_date);
			Date d2 = new SimpleDateFormat("dd/MM/yyyy").parse(today);
			long diff = d2.getTime() - d1.getTime();
			days=(diff / (1000 * 60 * 60 * 24));
			int fee=(int) (2*days);
			refund=fee_deposit-fee;
			
		}
}catch(Exception e){}
		
%>
<div id="container">
<div id="demo"></div>

<table border=1>
	<tr>
		<td class="key">Username(Email)</td><td class="value"><%=mem_id%></td>
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
		<td class="key">Due Date of Renewal</td><td class="value"><%=mem_due_renewal_date%></td>
	</tr>
	<tr>
		<td class="key">Total Money Deposit</td><td class="value">Rs.<%=fee_deposit%></td>
	</tr>
	<tr>
	<%if(refund<0){ %>
		<td class="key" style="background-color:#ff6666">Due Money</td><td class="value" style="background-color:#ff6666">Rs.<%=-refund%>&nbsp;(due)</td>
		<%} else{%>
		<td class="key">Remaining Money</td><td class="value">Rs.<%=refund%></td>
		<%} %>
	</tr>
	<tr>
		<td class="key">Action</td><td class="value" id="pay">
		<form action="payment" method="post">
			<input type="number" min="100" name="payment" required>
			<input type="hidden"  name="mem_id" value=<%=mem_id %>>
			<input type="hidden" name="lib_id" value=<%=user%>>
			<input type="hidden" name="payment_date" value=<%=today%>>
			<input type="hidden" name="renewal_date" value=<%=mem_due_renewal_date%>>
			<input type="submit" value="Pay Money" title="Pay to increase the renewal date">
		</form>
		</td>
	</tr>
	

</table>
		
</div>
<script type="text/javascript">
<%if(payment_status!=null){%>
function Paymemt_status() {
	document.getElementById("demo").innerHTML='<%=payment_status%>';
}
window.onload=Paymemt_status;
<%}%>

</script>
</body>
</html>

