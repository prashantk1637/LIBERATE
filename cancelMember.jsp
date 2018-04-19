<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.liberate.IssuedBookedDetailsBean"%>
<%@page import="java.util.ArrayList"%>
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
td img{
width:80px;
height:100px;
background-image: url('/Liberate/books/no_preview.png')
}

#left_table{
border-collapse: collapse;
width:20%;
float:left;
}
#right_table{
border-collapse: collapse;
width:80%;
float:left;
}
.key{
background:white;
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
width: 200px;
}
.btn{
height:30px;
width:150px;
border-radius: 3px;
cursor:pointer;
background: orange;
}
</style>
</head>

<body>
<%
HttpSession s=request.getSession(false);
String user=(String)s.getAttribute("user");
String userType=(String)s.getAttribute("userType");
if(user==null)
	response.sendRedirect("/Liberate?error=Login+first");
if(!userType.equals("librarian"))
	response.sendRedirect("error.jsp"); //Accessed denied for all type of users except Librarian

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
	<li class="nav-item" style="color:orange"><a href="<%=home%>">Home</a></li>
	<li class="nav-item"><a href="bookcatalog.jsp">Browse</a></li>
	<li class="nav-item"><a href="search.jsp">Search book</a></li>
	<li class="nav-item" style="color:orange"><%="Welcome "+user%></li>
	<li class="nav-item"><a href="logout.jsp" style="color:red;"><b>Logout</b></a></li>
	</ul>


</div>
<% 
String username=null,password=null,name=null,dob=null,gender=null,address=null,mem_type=null,mem_reg_date=null,cancellation_date=null,mem_expiry_date=null;
int fee_deposit=0,refund=0;
long days=0;
PreparedStatement pstmt=null;	
ArrayList<IssuedBookedDetailsBean> list=new ArrayList<>();
username=request.getParameter("mem_id");
String sql0="select * from member where email=?";
String sqli="select amount from payment where mem_id=?";
String sql="select accession_no,req_for_issue_date,issue_date,return_date, issue_approval from issue where mem_id=? and issue_approval=?";
int flag=0;
int amt=0,total_fee=0;
try{
		Class.forName("com.mysql.jdbc.Driver");  
		Connection con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
		pstmt=(PreparedStatement) con.prepareStatement(sqli);
		
		pstmt.setString(1,username);
		ResultSet rs=(ResultSet) pstmt.executeQuery();
		
		while(rs.next())
		{
			amt=amt+rs.getInt(1);
		}
		pstmt=(PreparedStatement) con.prepareStatement(sql0);
		pstmt.setString(1,username);
		rs=(ResultSet) pstmt.executeQuery();
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
			total_fee=fee_deposit+amt;
			DateFormat df=new SimpleDateFormat("dd/MM/yyyy");
			Date d=new Date();
			cancellation_date=df.format(d);
			Date d1 = new SimpleDateFormat("dd/MM/yyyy").parse(mem_reg_date);
			Date d2 = new SimpleDateFormat("dd/MM/yyyy").parse(cancellation_date);
			long diff = d2.getTime() - d1.getTime();
			days=(diff / (1000 * 60 * 60 * 24));
			int fee=(int) (2*days);
			refund=total_fee-fee;
			}
		else {flag=1;}
		pstmt=(PreparedStatement) con.prepareStatement(sql);
		pstmt.setString(1, username);
		pstmt.setString(2, "issued");
		rs=(ResultSet) pstmt.executeQuery();
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
				obj.setReq_for_issue_date(rs.getString(2));
				obj.setIssue_date(rs.getString(3));
				obj.setReturn_date(rs.getString(4));
				obj.setIssue_approval(rs.getString(5));
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
	
}catch(Exception e){}

%>
<span style="font-size: 30px;background:silver">Membership Cancellation Panel</span><br>
<%if(flag==0){ %>
<span>Member's Details</span><br>
<table border=1 id="left_table">
	<tr>
		<td class="key">Member Email</td><td class="value"><%=username%></td>
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
		<td class="key">Due Date of Renewal</td><td class="value"><%=mem_expiry_date%></td>
	</tr>
	<tr>
		<td class="key">Total fee Deposit</td><td class="value"><%=total_fee%></td>
	</tr>

</table>
<%if(list.size()>0){ %>
<span style="color:red"><b>List of issued books</b></span><br><span><b>Note:-</b>Please return these books before membership cancellation<a href="librarian.jsp?cancel=return" style="color:blue">click here</a></span>
<table border=1 style="text-align:center;background:white" id="right_table">
					<tr>
						<th>Accession No</th>
						<th>View</th>
						<th>Title</th>
						<th>Author</th>
						<th>Edition</th>
						<th>ISBN</th>
						<th>Publisher</th>
						<th>Publication Year</th>
						<th>Issue Date</th>
						<th>Return Date</th>
					</tr>
		<% for(IssuedBookedDetailsBean o: list){%>
			<%
			
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
				String req_for_issue_date=o.getReq_for_issue_date();
				String issue_date_db=o.getIssue_date();
				String return_date_db=o.getReturn_date();
				String issue_approval=o.getIssue_approval();%>
					<tr><td><%=accession_no %></td>
						<td><img src=<%=path %> /></td>
						<td><%=title%></td>
						<td><%=author%></td>
						<td><%=edition%></td>
						<td><%=isbn%></td>
						<td><%=publisher%></td>
						<td><%=publication_year%></td>
						<td><%=issue_date_db %></td>
						<td><%=return_date_db %></td>
						
						</tr>	
		<%}%>
		</table>
	<%} %>
	
	<%if(list.size()==0) {%>
	<div style="float:right;margin-right:20px;background:lightpink;padding:50px;">
	<p style="color:green;font-size:20px">No any issued books pending</p>
	<p>Cancellation date:&nbsp;<%=cancellation_date%></p>
	<table border="1" style="border-collapse: collapse;">
	<tr>
		<th>Amount(&#8377;)</th>
		<th>Refund/Due</th>
	</tr>
	<%if(refund>=0){%>
	<tr> 
		<td><%=refund %></td>
		<td>Refund</td>
	</tr>
	<%} %>
	<%if(refund<0){%>
	<tr> 
		<td><%=-refund %></td>
		<td>Due</td>
	</tr>
	<%} %>
	
	
	
	</table>
		<form action="cancelMember" method="post">
		<input type="hidden" name="mem_id" value=<%=username%>>
		<input type="hidden" name="mem_name" value=<%=name%>>
		<input type="hidden" name="lib_id" value=<%=user%>>
		<input type="hidden" name="cancel_date" value=<%=cancellation_date%>>
		<%if(refund>=0){%>
			<input type="hidden" name="amount" value=<%=refund%>>
			<input type="hidden" name="due_refund" value="refund">
		<%} %>
		<%if(refund<0){%>
			<input type="hidden" name="amount" value=<%=-refund%>>
			<input type="hidden" name="due_refund" value="due">
		<%} %>
		<input type="submit" class="btn" value="Cancel Membership">
		</form>
	</div>
	
	<%} %>
		
	
	<%} else out.print("<h2>Member does not exist</h2>"); %>	
		
</body>
</html>