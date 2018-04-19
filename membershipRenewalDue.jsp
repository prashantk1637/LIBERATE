<!--
******************************
This is book due by member page
******************************
-->
<%@page import="com.liberate.MembershipRenewalDueBean"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.liberate.IssuedBookedDetailsBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.mysql.jdbc.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="com.mysql.jdbc.Connection"%>
<%@page import="com.mysql.jdbc.PreparedStatement"%>
<html !DOCTYPE="html">
<head>
<title>LIBERATE</title>
<link rel="stylesheet" type="text/css" href="librarian.css"/>
<style>

.drop-down{
display:none;
}
#nav ul li:hover .drop-down{
	
display:block;
 background:#2471A3;
 position:absolute;
 list-style:none;
 min-height:50px;
float:left;
padding: 4px;
border-radius:5px; 
 }
 #nav ul li .drop-down li a{
 font-size: 15px;
 border-bottom: 1px solid yellow;
 text-align: left;
 line-height: 30px;
 }
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
td{
padding: 10px;
}
td img{
width:80px;
height:100px;
background-image: url('/Liberate/books/no_preview.png')
}
table{
border-collapse: collapse;
width:98%;
margin:1%;
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
		String notified_member=(String)request.getAttribute("mem_id");
		String notified_notification=(String)request.getAttribute("notification");
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
	<li class="link"><a href="librarian.jsp" title="Home">Home</a></li>
	<li class="link"><a href="search.jsp" title="Book Search">Book Search</a></li>
	<li class="link"><a href="showpopularbook.jsp" title="It will show popular and demanding books">Popular Books</a></li>
	
	<li class="link"><a href="#">Follow Up Lists</a>
			<ul class="drop-down">
				<li><a href="bookDueFromMember.jsp" style="text-align:center" >Books-Due-from-Members</a></li>
				<li><a href="membershipRenewalDue.jsp"  style="text-align:center">Membership-Renewal-due</a></li>
				
			</ul>
	</li>
	

	<li class="link" style="color:white">Welcome!&nbsp;&nbsp;<span style="color:orange"><b><%=user%></b></span></li>
	<li class="link" class="nav-item"><a href="logout.jsp" style="color:red;"><b>Logout</b></a></li>
	</ul>


</div>
<%
PreparedStatement pstmt=null;
ArrayList<MembershipRenewalDueBean> renewal_list=new ArrayList<>();
SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
SimpleDateFormat df1 = new SimpleDateFormat("yyyy-MM-dd");
String mem_id=null,name=null,mem_type=null,renew_date=null,today=null;
String sql="select email,name,mem_type, expiry_date from member";
try{	
		Date d=new Date();
		today=df.format(d);
		Class.forName("com.mysql.jdbc.Driver");  
		Connection con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
		pstmt=(PreparedStatement) con.prepareStatement(sql);
		ResultSet rs=(ResultSet)pstmt.executeQuery();
		while(rs.next())
		{
			Date date = df.parse(rs.getString(4));
		 	String renewal_date=df1.format(date);
		 	Date td=df.parse(today);
			String tday=df1.format(td);
			if(df1.parse(tday).compareTo(df1.parse(renewal_date))>0)
			{
				MembershipRenewalDueBean obj=new MembershipRenewalDueBean();
				obj.setMem_id(rs.getString(1));
				obj.setName(rs.getString(2));
				obj.setMem_type(rs.getString(3));
				obj.setRenewal_date(rs.getString(4));
				renewal_list.add(obj);
			}
		}
			
		
	
	}catch (Exception e) {}


%>
<div id="container">
<h2 style="float: right;">Membership renewal Due</h2>
<table border=1 style="text-align:center;background:white">
					<tr>
						<th>Member Id</th>
						<th>Name</th>
						<th>Member Type</th>
						<th>Renewal Date</th>
						<th>Action</th>
					</tr>
		 	
		 	
			<%for(MembershipRenewalDueBean o: renewal_list){
			
				mem_id=o.getMem_id();
				name=o.getName();
				mem_type=o.getMem_type();
				String notification="Please renew your account";
				renew_date=o.getRenewal_date();%>
					<tr>
					<td><%= mem_id%></td>
					<td><%=name%></td>
					<td><%=mem_type %></td>
					<td><%=renew_date %></td>
							
						<td>
							<form action="notification" method="post">
									<input type="hidden" name="mem_id" value=<%=mem_id %>>
									<input type="hidden" name="notification" value='<%=notification%>'>
									<input type="hidden" name="due_date" value=<%=renew_date%>>
									<input type="hidden" name="notification_date" value=<%=today %>>
									<input type="hidden" name="flag" value="memberdue">
									<input type="submit" class="btn" id="notify" value="Notify">
							</form>
						</td>
						
					</tr>
				<%} %>
		</table>
		
</div>
<script type="text/javascript">
<%if(notified_member!=null){%>
function notify() {
	alert('<%=notified_member%>'+' has been notifed');
}
window.onload=notify;
<%}%>
</script>
<div id="footer">
<p style="text-align:center;color:white;">Copyright © All Rights Reserved 2017</p>

</div>
</body>
</html>

