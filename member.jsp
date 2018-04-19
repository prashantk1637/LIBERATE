<!--
******************************
This is member home page
******************************
-->
<%@page import="com.mysql.jdbc.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="com.mysql.jdbc.Connection"%>
<%@page import="com.mysql.jdbc.PreparedStatement"%>
<html DOCTYPE="html">
<head>
<title>LIBERATE</title>
<link rel="stylesheet" type="text/css" href="member.css"/>

</head>

<body>

<%

	HttpSession s=request.getSession(false);
	String user=(String)s.getAttribute("user");
	String userType=(String)s.getAttribute("userType");
	String interest=request.getParameter("interest");
%>
<%if(user==null) {%>
<% response.sendRedirect("/Liberate?error=login+first");%>
<%} 
else if(userType.equals("librarian")) {%>
 <%response.sendRedirect("error.jsp");%>
<%}%>
<div id="header">
	<div id="logo"><img src="logo.png" alt="logo"/></div>
	<div id="banner"><img src="banner2.png" alt="image"/></div>
</div>
<%

	String sql="select email from existinguser where email=?";
	String insertNewUser="insert into existinguser values(?,?)";
	String notification="select count(*) from notification where mem_id=? and catchup=?";
	int notification_count=0;
	PreparedStatement pstmt;
	int newuser=0;
	Connection con;
	try {
		Class.forName("com.mysql.jdbc.Driver");
		con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");
		pstmt=(PreparedStatement) con.prepareStatement(sql);
		pstmt.setString(1, user);
		ResultSet rs=(ResultSet)pstmt.executeQuery();
		if(rs.next())
		{
			newuser=0;
		}
			
		else
		{	newuser=1;
			pstmt=(PreparedStatement) con.prepareStatement(insertNewUser);
			pstmt.setString(1, user);
			pstmt.setString(2, userType);
			pstmt.executeUpdate();
		}
		
		pstmt=(PreparedStatement) con.prepareStatement(notification);
		pstmt.setString(1, user);
		pstmt.setString(2, "NO");
		rs=(ResultSet)pstmt.executeQuery();
		if(rs.next())
		{
			notification_count=rs.getInt(1);
		}
	}catch(Exception e){}

%>
<div id="nav">
	<ul>
	<li title="profile details" class="nav-item" style="color:orange"><a href="profile.jsp">Profile</a></li>
	<li title="Issued books listing" class="nav-item"><a href="issuedDetails">Issue Status</a></li>
	<li title="Returned books listing" class="nav-item"><a href="returnStatus">Return Status</a></li>
	<li style="color:white" class="nav-item">Welcome!&nbsp;&nbsp;<span style="color:orange"><b><%=user%></b></span></li>
	<li class="nav-item"><a href="logout.jsp" style="color:red;"><b>Logout</b></a></li>
	<li class="nav-item"><a title="notifications" href="notification.jsp">
		<img src="/Liberate/books/notification.png" style="position:absolute;width:25px;height:25px;"/>
		&nbsp;&nbsp;&nbsp;&nbsp;<span style="position:absolute;width:15px;height:23px;border-radius:3px;background:orange;"><%=notification_count %></span></a></li>
	</ul>


</div>

<%if(newuser==1) {%>
			<div id="newuser">
				<a href="#" onclick="home()" class="cross">&#10060;</a><br>
				<span style="color:green;font-size:20px;"><b>Thank you for being member of LIBERATE</b></span><br>
				<span style="color:white;font-size:20px;">We want to know your area of interests</span>(You can tick more than one checkbox)
				<form action="userinterest" method="post">
					<input type="hidden" name="email" value=<%=user %>>
					<input type="checkbox" name="ch1" value="cse">Computer Science<br>
					<input type="checkbox" name="ch2" value="it">Information Technology<br>
					<input type="checkbox" name="ch3" value="ece">Electronics and communication<br>
					<input type="checkbox" name="ch4" value="me">Mechanical Engineering<br>
					<input type="checkbox" name="ch5" value="ee">Electrical Engineering<br>
					<input type="checkbox" name="ch6" value="ce">Civil Engineering<br>
					<input type="checkbox" name="ch6" value="chemical">Chemical Engineering<br>
					<input type="checkbox" name="ch6" value="bt">Biotechnology<br>
					<input type="checkbox" name="ch7" value="math">Mathematics<br>
					<input type="checkbox" name="ch8" value="phy">Physics<br>
					<input type="checkbox" name="ch9" value="che">Chemistry<br>
					<input type="checkbox" name="ch10" value="bio">Biology<br>
					<input type="text"  class="field"  autocomplete="off" name="other" placeholder="Please specify here..."><span>If none of above relevant to you</span><br>
					<input type="submit" class="btn" value="SUBMIT">
				</form>
			
			
			</div>
			<%} %>
<div id="container">

	<div id="left">

	<ul>
	<li class="panel"><a href="bookCatalog">Browse</a></li>
	<li class="panel"><a href="reservedBoooks.jsp">Reserved Books</a></li>
	<li class="panel"><a href="search.jsp" >Standard Search</a></li>
	<li class="panel"><a href="advanceSearch.jsp">Advanced Search</a></li>
	<li class="panel"><a href="isbnSearch.jsp">ISBN Search</a></li>
	
	</ul>

	</div>
	
	
	
	<div id="right">

		
		





	</div>
	
	
	
</div>
<script type="text/javascript">
<%if(newuser==1){%>
function fun() {
	nav.style.opacity="0.4";
	nav.style.pointerEvents="none";
	container.style.opacity="0.4";
	container.style.pointerEvents="none";
	
	}
window.onload=fun;
<%}%>
<%if(interest!=null){%>
function interest() {
	alert('<%=interest%>');
	
	}
window.onload=interest;
<%}%>
function home()
{
	document.getElementById("newuser").style.display="none";
	nav.style.opacity="1";
	nav.style.pointerEvents="auto";
	container.style.opacity="1";
	container.style.pointerEvents="auto";

}
</script>
</body>

</html>

