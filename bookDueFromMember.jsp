<!--
******************************
This is book due by member page
******************************
-->
<%@page import="java.util.HashSet"%>
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
<%HashSet<Integer> accession_set=new HashSet<>(); %>
<%
		HttpSession s=request.getSession(false);
		String user=(String)s.getAttribute("user");
		String userType=(String)s.getAttribute("userType");
		String notify_all=(String)request.getAttribute("notifyall");
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
				<li><a href="membershipRenewalDue.jsp" style="text-align:center">Membership-Renewal-due</a></li>
			</ul>
	</li>
	

	<li class="link" style="color:white">Welcome!&nbsp;&nbsp;<span style="color:orange"><b><%=user%></b></span></li>
	<li class="link" class="nav-item"><a href="logout.jsp" style="color:red;"><b>Logout</b></a></li>
	</ul>


</div>
<%
PreparedStatement pstmt=null;
ArrayList<IssuedBookedDetailsBean> list=new ArrayList<>();
String sql="select accession_no,mem_id,issue_date,return_date from issue where issue_approval=?";
try{
		Class.forName("com.mysql.jdbc.Driver");  
		Connection con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
		pstmt=(PreparedStatement) con.prepareStatement(sql);
		pstmt.setString(1, "issued");
		ResultSet rs=(ResultSet) pstmt.executeQuery();
		
		while(rs.next())
		{
			String sql1="select path,title,author,subject,edition,isbn,publisher,publication_year from books where accession_no=?";
			pstmt=(PreparedStatement) con.prepareStatement(sql1);
			pstmt.setInt(1,rs.getInt(1));
			ResultSet rs1=(ResultSet) pstmt.executeQuery();
			if(rs1.next())
			{
				IssuedBookedDetailsBean obj=new IssuedBookedDetailsBean();
				obj.setAccession_no(rs.getInt(1));
				obj.setMem_id(rs.getString(2));
				obj.setIssue_date(rs.getString(3));
				obj.setReturn_date(rs.getString(4));
				obj.setPath(rs1.getString(1));
				obj.setTitle(rs1.getString(2));
				obj.setAuthor(rs1.getString(3));
				obj.setSubject(rs1.getString(4));
				obj.setEdition(rs1.getString(5));
				obj.setIsbn(rs1.getString(6));
				obj.setPublisher(rs1.getString(7));
				obj.setPublication_year(rs1.getInt(8));
				list.add(obj);
			}
		}
	con.close();
	}catch (Exception e) {}


%>
<div id="container">
<h2 style="float: right;">Book due from Members</h2>
<%if(list.size()>1){ %>
<h3 style="float: left;position: fixed;padding-left:10px;border:groove;" class="btn">

<a  href="notifyAll" style="color:black;" >Notify All</a>
<%}%>


</h3>
<table border=1 style="text-align:center;background:white">
					<tr>
						<th>Accession No</th>
						<th>Title</th>
						<th>Author</th>
						<th>Edition</th>
						<th>ISBN</th>
						<th>Publisher</th>
						<th>Issue Date</th>
						<th>Due Date</th>
						<th>Issued By</th>
						<th>Action</th>
					</tr>
		<% 	SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
		 	SimpleDateFormat df1 = new SimpleDateFormat("yyyy-MM-dd");
		 	Date d=new Date();
		 	String today=df.format(d);
		 	
			for(IssuedBookedDetailsBean o: list){
			
				int accession_no=o.getAccession_no();
				String path=o.getPath();
				String title=o.getTitle();
				String author=o.getAuthor();
				String subject=o.getSubject();
				String edition=o.getEdition();
				String isbn=o.getIsbn();
				String publisher=o.getPublisher();
				int publication_year=o.getPublication_year();
				String mem_id=o.getMem_id();
				String notification="Return book titled: "+title+" by "+author;
				String issue_date_db=o.getIssue_date();
				String due_date_db=o.getReturn_date();
				Date date = df.parse(due_date_db);
			 	String due_date=df1.format(date);
				Date td=df.parse(today);
				String tday=df1.format(td);
				if(df1.parse(tday).compareTo(df1.parse(due_date))>=0){%>
					<tr><td><%=accession_no %></td>
						<td><%=title%></td>
						<td><%=author%></td>
						<td><%=edition%></td>
						<td><%=isbn%></td>
						<td><%=publisher%></td>
						<td><%=issue_date_db%></td>
						<td><%=due_date_db%></td>
						<td><%=mem_id%></td>
						<td>
								<form action="notification" method="post">
									<input type="hidden" name="mem_id" value=<%=mem_id %>>
									<input type="hidden" name="notification" value='<%=notification%>'>
									<input type="hidden" name="due_date" value=<%=due_date_db %>>
									<input type="hidden" name="notification_date" value=<%=today %>>
									<input type="hidden" name="flag" value="bookdue">
									<input type="submit" class="btn" id="notify" value="Notify">
								</form>
						</td>
						
					</tr>
				<%} %>
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
<%if(notify_all!=null){%>
function notify() {
	alert('<%=notify_all%>');
}
window.onload=notify;
<%}%>


</script>
<div id="footer">
<p style="text-align:center;color:white;">Copyright © All Rights Reserved 2017</p>

</div>
</body>
</html>

