<!--
******************************
This is librarian home page

******************************
-->
<%@page import="recommendation.ItemSimilarity"%>
<%@page import="recommendation.ItemSimilarityBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.liberate.ReservedBookBean"%>
<%@page import="com.liberate.ReserveToIssue"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="com.mysql.jdbc.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.liberate.ReturnStatusBean"%>
<%@page import="com.liberate.AutomaticBookDueNotification"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Random"%>
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
</style>
</head>

<body>
<%
	//HttpSession s=(HttpSession)request.getAttribute("librarian-session");
	HttpSession s=request.getSession(false);
	String user=(String)s.getAttribute("user");
	String userType=(String)s.getAttribute("userType");
	DateFormat df=new SimpleDateFormat("dd/MM/yyyy");
	Date d=new Date();
	String reg_date=df.format(d);// today will be the registration date
	String stmt_action="default",heading="default";
	 
%>
<%if(user==null) {%>
<% response.sendRedirect("/Liberate?error=login+first");%>
<%} 
else if(!userType.equals("librarian")) {%>
 <%response.sendRedirect("error.jsp");%>
<%}%>
<%
/// automatic notification once in a day
String today=df.format(d);
PreparedStatement pstmt=null;
String sql="select notification_date from notification where notification_date=?";
int isnotify=0;
try{
Class.forName("com.mysql.jdbc.Driver");  
Connection con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
pstmt=(PreparedStatement) con.prepareStatement(sql);
pstmt.setString(1, today);
ResultSet rs=(ResultSet)pstmt.executeQuery();
while(rs.next()){isnotify=1;}
if(isnotify==0){
AutomaticBookDueNotification ob=new AutomaticBookDueNotification();
ob.notification();}
}catch(Exception e){}

%>


<% 
	
	String inserted=request.getParameter("insert");
   String mem_add=request.getParameter("mem_add");
   String mem_cancel=request.getParameter("mem_cancel");
   String returned=request.getParameter("returned");
   String return_mem_cancel=request.getParameter("cancel");
   String mem_reg_stmt=request.getParameter("mem_reg_stmt");
   String mem_renewal_stmt=request.getParameter("mem_renewal_stmt");
   String mem_cancel_stmt=request.getParameter("mem_cancel_stmt");
   String fine_stmt=request.getParameter("fine_stmt");
   %>
   
   
 <% 
   int accession_no=0,fine=0; 
  	String mem_id=null,mem_type=null,issue_date=null,due_date=null,return_date=null,return_status=null;
	Object obj=request.getAttribute("RETURN");
	if(obj!=null)
	{
		ReturnStatusBean o=(ReturnStatusBean)obj;
		accession_no=o.getAccession_no();
		mem_id=o.getMem_id();
		mem_type=o.getMem_type();
		issue_date=o.getIssue_date();
		due_date=o.getDue_date();
		return_date=o.getReturn_date();
		fine=o.getFine_paid();
		return_status=o.getReturned_approval();
	}
%>



<%	 //auto passwod generation 
char a[]={'A','B','C','D','E','F','a','b','c','@','#','$','0','1','2','3','4','5'};
Random random = new Random();

for( int i=0 ; i<a.length ; i++ )
{
    int j = random.nextInt(a.length);
    // Swap letters
    char temp = a[i]; a[i] = a[j];  a[j] = temp;
} 
String str=new String( a );
String autoPass=str.substring(0, 6);
%>

<div id="header">
	<div id="logo"><img src="logo.png" alt="logo"/></div>
	<div id="banner"><img src="banner2.png" alt="image"/></div>
</div>

<div id="nav">
	<ul>
	<li class="link"><a href="bookcatalog.jsp" title="List of all books">Browse</a></li>
	<li class="link"><a href="search.jsp" title="Book Search">Book Search</a></li>
	<li class="link"><a href="showpopularbook.jsp" title="It will show popular and demanding books">Books in demand</a></li>
	
	<li class="link"><a href="#">Follow Up Lists</a>
			<ul class="drop-down">
				<li><a href="bookDueFromMember.jsp" style="text-align:center" >Books-Due-from-Members</a></li>
				<li><a href="membershipRenewalDue.jsp"  style="text-align:center">Membership-Renewal-due</a></li>
			
			</ul>
	</li>
	
	<li class="link"><a href="#">Statements</a>
			<ul class="drop-down">
				<li><a href="#membership-registration-stmt" onclick="mem_reg_stmt(1)" style="text-align:center" >Membership Registrations</a></li>
				<li><a href="#" onclick="mem_reg_stmt(2)" style="text-align:center">Membership Renewals</a></li>
				<li><a href="#"  onclick="mem_reg_stmt(3)" style="text-align:center">Membership Cancelled</a></li>
				<li><a href="#"  onclick="mem_reg_stmt(4)" style="text-align:center">Fines Collected</a></li>
				
			</ul>
	</li>

	<li class="link" style="color:white">Welcome!&nbsp;&nbsp;<span style="color:orange"><b><%=user%></b></span></li>
	<li class="link" class="nav-item"><a href="logout.jsp" style="color:red;"><b>Logout</b></a></li>
	</ul>


</div>
<div id="container">
	<div id="left">

	<ul>
	<li class="panel"><a href="#" onclick="home()">Home</a></li>
	<li class="panel"><a href="#addBook" onclick="bookIntry()">Book Entry</a></li>
	<li class="panel"><a href="#addStudent" onclick="addStudent()">Member Registration</a></li>
	<li class="panel"><a href="#cancelMember" onclick="cancelMember()">Member Cancellation</a></li>
	<li class="panel"><a href="#renewalMember" onclick="renewalMember()">Member Renewal</a></li>
	
	<li class="panel"><a href="#issueBook" onclick="issueBook()">Issued Book Approval</a></li>
	<li class="panel"><a href="#returnBook" onclick="returnBook()">Book Return</a></li>
	<li class="panel"><a href="notice.jsp">Publish a notice</a></li>
	</ul>

	</div>
	
	
	
	<div id="right">

	<div id="addBook" class="backg">
	<a href="#" onclick="home()" class="cross" title="Close">&#10060;</a>
	<h2 style="text-align:center">BOOK ENTRY<span id="demo" style="color:green"></span></h2>
	<form action="addbooks" method="post">
	<table>
		<tr>
			<td>Book Preview Location</td><td><input class="field" id="blocation" type="text" name="path" placeholder="cover image location(optional)"/></td>
		</tr>
		<tr>
			<td>Title<span style="color:red">*</span></td><td><input class="field" id="btitle" type="text" name="title" required/></td>
		</tr>
		<tr>
			<td>Author<span style="color:red">*</span></td><td><input class="field" id="bauthor" type="text" name="author" required/></td>
		</tr>
		<tr>
			<td>Subject<span style="color:red">*</span></td><td><input  class="field" id="bsubject" type="text" name="subject" required/></td>
		</tr>
		<tr>
			<td>Keywords<span style="color:red">*</span></td><td><input  class="field" id="bkeyword" type="text" name="keyword" required placeholder="Ex. software:network etc."/></td>
		</tr>
		<tr>
			<td>Classification Number<span style="color:red">*</span></td><td><input class="field" id="bc_no" type="text" name="c_no" required/></td>
		</tr>
		<tr>
			<td>ISBN<span style="color:red">*</span></td><td><input class="field" id="bisbn" type="text" name="isbn" required/></td>
		</tr>
		<tr>
			<td>Edition<span style="color:red">*</span></td><td><input class="field" id="bedition" type="text" name="edition" required/></td>
		</tr>
		<tr>
			<td>Publisher<span style="color:red">*</span></td><td><input class="field" id="bpublisher" type="text" name="publisher" required/></td>
		</tr>
		<tr>
			<td>Publication Year<span style="color:red">*</span></td><td><input class="field" id="bp_year" type="number" name="p_year" required/></td>
		</tr>
		<tr>
			<td></td>
			<td><input type="submit" class="btn" value="ADD"></td>
			<td><input type="button" onclick="resetFun1()" class="btn" style="background:#E0DBDA" value="RESET"></td>
		<tr>
	</table>
	</form>
	<p>Note:-&nbsp;<span style="color:red">*</span>Fields are mandatory</p>
	</div>


	<div id="addStudent" class="backg">
		<a href="#" onclick="home()" class="cross" title="Close">&#10060;</a>
		<h2 style="text-align:center">Member Registration<span id="demo1" style="color:green;font-weight: bolder;"></span></h2>
		<form action="addmember" method="post">
			<table>
				<tr>
					<td>Email(Username)<span style="color:red">*</span></td><td><input  class="field" type="email" id="email" name="email" required/></td>
				</tr>
				<tr>
					<td>Auto generated<br>Password<span style="color:red">*</span></td><td><input type="text" class="field" id="pass" name="pass" value=<%=autoPass %> required/></td>
				</tr>
				<tr>
					<td>Name<span style="color:red">*</span></td><td><input  class="field" type="text" id="name" name="name" required/></td>
				</tr>
				<tr>
					<td>Date of Birth<span style="color:red">*</span></td>
					<td>
						<select name="day" style="border-radius:3px;height:30px;" required>
							<option value="">Day&nbsp;&nbsp;</option>
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
							<option value="6">6</option>
							<option value="7">7</option>
							<option value="8">8</option>
							<option value="9">9</option>
							<option value="10">10</option>
							<option value="11">11</option>
							<option value="12">12</option>
							<option value="13">13</option>
							<option value="14">14</option>
							<option value="15">15</option>
							<option value="16">16</option>
							<option value="17">17</option>
							<option value="18">18</option>
							<option value="19">19</option>
							<option value="20">20</option>
							<option value="21">21</option>
							<option value="22">22</option>
							<option value="23">23</option>
							<option value="24">24</option>
							<option value="25">25</option>
							<option value="26">26</option>
							<option value="27">27</option>
							<option value="28">28</option>
							<option value="29">29</option>
							<option value="30">30</option>
							<option value="31">31</option>
							
							</select>
							<select name="month" style="border-radius:3px;height:30px;" required>
							<option value="">Month&nbsp;</option>
							<option value="1">Jan</option>
							<option value="2">Feb</option>
							<option value="3">Mar</option>
							<option value="4">Apr</option>
							<option value="5">May</option>
							<option value="6">Jun</option>
							<option value="7">Jul</option>
							<option value="8">Aug</option>
							<option value="9">Sept</option>
							<option value="10">Oct</option>
							<option value="11">Nov</option>
							<option value="12">Dec</option>
							
							</select>
							<select name="year" style="border-radius:3px;height:30px;" required>
							<option value="">Year&nbsp;</option>
							<option value="2011">2011</option>
							<option value="2010">2010</option>
							<option value="2009">2009</option>
							<option value="2008">2008</option>
							<option value="2007">2007</option>
							<option value="2006">2006</option>
							<option value="2005">2005</option>
							<option value="2004">2004</option>
							<option value="2003">2003</option>
							<option value="2002">2002</option>
							<option value="2001">2001</option>
							<option value="2000">2000</option>
							<option value="1999">1999</option>
							<option value="1998">1998</option>
							<option value="1997">1997</option>
							<option value="1996">1996</option>
							<option value="1995">1995</option>
							<option value="1994">1994</option>
							<option value="1993">1993</option>
							<option value="1992">1992</option>
							<option value="1991">1991</option>
							<option value="1990">1990</option>
							<option value="1989">1989</option>
							<option value="1988">1988</option>
							<option value="1987">1987</option>
							<option value="1986">1986</option>
							<option value="1985">1985</option>
							<option value="1984">1984</option>
							<option value="1983">1983</option>
							<option value="1982">1982</option>
							<option value="1981">1981</option>
							<option value="1980">1980</option>
							<option value="1979">1979</option>
							<option value="1978">1978</option>
							<option value="1977">1977</option>
							<option value="1976">1976</option>
							<option value="1975">1975</option>
							<option value="1974">1974</option>
							<option value="1973">1973</option>
							<option value="1972">1972</option>
							<option value="1971">1971</option>
							<option value="1970">1970</option>
							</select>
					</td>
				</tr>
				<tr>
					<td>Gender<span style="color:red">*</span></td><td>Male<input type="radio" name="gender" value="male" required/>Female<input type="radio"  name="gender" value="female" required/></td>
				</tr>
				
				<tr>
					<td>Address<span style="color:red">*</span></td><td><input  class="field" type="text" id="address" name="address" required/></td>
				</tr>
				<tr>
					<td>Member Type<span style="color:red">*</span></td><td>
										<select class="field" name="usertype" required>
											<option value="">Select Member type</option>
											<option value="teacher">Teacher</option>
											<option value="student">Student</option>
										</select>
									</td>
				</tr>
				<tr>
					<td>Registration Date</td>
					<td><input type="text" class="field" name="r_date" value=<%=reg_date%>></td>
				</tr>
				
				<tr>
					<td>Fee deposit<span style="color:red">*</span></td><td><input   class="field" type="number" id="fee" name="feedeposit" required min="100" max="1000"/></td>
				</tr>
				
				
				<tr>
					<td></td>
					<td><input class="btn" type="submit" value="ADD"></td>
					<td><input type="button" onclick="resetFun2()" class="btn" style="background:#E0DBDA" value="RESET"></td>
				<tr>
			</table>
		</form>
	</div>



<div id="issueBook" class="backg">
<a href="#" onclick="home()" class="cross" title="Close">&#10060;</a>
<h2 style="text-align:center">BOOK ISSUE</h2>
<form action="approval" method="post">
<table>
<tr>
<td>Member Id</td><td><input  class="field"  type="text" name="mem_id" required autocomplete="off"/></td>
</tr>
<tr>
<td></td>
<td><input class="btn" type="submit" value="OK"></td>
<tr>
</table>
</form>
</div>

<div id="cancelMember" class="backg">
<a href="#" onclick="home()" class="cross" title="Close">&#10060;</a>
<h2 style="text-align:center">Member Cancellation <span id="demo3" style="color:green;"></span></h2>
<form action="cancelMember.jsp" method="post">
<table>
<tr>
<td>Member Id</td><td><input  class="field"  type="text" name="mem_id" required autocomplete="off"/></td>
</tr>
<tr>
<td></td>
<td><input class="btn" type="submit" value="OK"></td>
<tr>
</table>
</form>
</div>

<div id="renewalMember" class="backg">
<a href="#" onclick="home()" class="cross" title="Close">&#10060;</a>
<h2 style="text-align:center">Member Renewal</h2>
<form action="renewalMember.jsp" method="post">
<table>
<tr>
<td>Member Id</td><td><input  class="field"  type="text" name="mem_id" required autocomplete="off"/></td>
</tr>
<tr>
<td></td>
<td><input class="btn" type="submit" value="OK"></td>
<tr>
</table>
</form>
</div>

<div id="returnBook" class="backg">
<a href="#" onclick="home()" class="cross" title="Close">&#10060;</a>
<h2 style="text-align:center">BOOK RETURN</h2>
<form action="bookReturnApproval.jsp" method="post">
<table>
<tr>
<td>Book Accession_No</td><td><input  class="field"  type="number" name="accession_no" required autocomplete="off" min="1"/></td>
</tr>
<tr>
<td></td>
<td><input class="btn" type="submit" value="OK"></td>
<tr>
<tr><td><p id="demo2" style="color:green"></p></td></tr>
</table>
</form>
</div>


<div id="membership-registration-stmt" class="backg">
<a href="#" onclick="home()" class="cross" title="Close">&#10060;</a>
<h2 style="text-align:center" id="stmt-heading"></h2>
<p id="error" style="color:green;"></p>
<form action="#" id="stmt-form" method="post">
<table>
<tr>
<td>Start Date</td><td><input title="Please enter start date" class="field"  type="date" name="from"/></td>
</tr>
<tr>
<td>End Date</td><td><input title="Please enter end date" class="field"  type="date" name="to"/></td>
</tr>
<tr>
<td></td>
<td><input class="btn" type="submit" value="OK"></td>
<tr>
</table>
</form>
</div>


<div id="returnStatus" class="backg">
<%if(obj!=null){%>
<a href="#" onclick="home()" class="cross" title="Close">&#10060;</a>
<%if(return_status.equals("pending")) {%>
<h3 style="text-align:center">CONFIRMATION PANEL</h3>
<%} %>
<%if(return_status.equals("returned")) {%>
<h3 style="text-align:center">RETURN DETAILS</h3>
<%} %>

<table>
	<tr>
		<td>Member Id</td><td><%=mem_id %></td>
	</tr>
	<tr>
		<td>Member type</td><td><%=mem_type %></td>
	</tr>
	
	<tr>
		<td>Accession No.</td><td><%=accession_no %></td>
		
	</tr>
	<tr>
		<td>Issue date</td><td><%=issue_date%></td>
	</tr>
	<tr>
		<td>Due date</td><td><%=due_date%></td>
	</tr>
	<tr>
		<td>Return date</td><td><%=return_date%></td>
	</tr>
	<tr>
		<td>Fine</td><td>&#8377;<%=fine %></td>
	
	</tr>
	<%if(return_status.equals("returned")) {%>
	<tr>
		<td>Return Status</td><td><b style="color: green"><%=return_status %></b></td>
	
	</tr>
	<%}%>
	<%if(return_status.equals("pending")) {%>
	<tr>
		<td>
			<form action="returned" method="post">
			<input type="hidden" name="accession_no" value='<%=accession_no%>'/>
			<input class="btn" type="submit" value="Confirm">
			</form>
		</td>
		<td>
			<input class="btn"  style="background: white" type="button" onclick="home()" value="Cancel">

		</td>
	
	</tr>
	<%} %>
	

</table>
</div>

<%}%>

</div>
	
	
	
</div>

<script>
<%if(return_mem_cancel!=null){%>
function cancel() {
	document.getElementById("returnBook").style.display="block";
}
window.onload=cancel;
<%}%>
<%if(inserted!=null){%>
function insertBookStatus() {
	document.getElementById("addBook").style.display="block";
	document.getElementById("demo").innerHTML='<%=inserted%>&#10004;';
}
window.onload=insertBookStatus;
<%}%>


<%if(mem_add!=null){%>
function insertMemberStatus() {
	document.getElementById("addStudent").style.display="block";
	document.getElementById("demo1").innerHTML='<%=mem_add%>&#10004;';
}
window.onload=insertMemberStatus;
<%}%>

<%if(mem_cancel!=null){%>
function cancelledMemberStatus() {
	document.getElementById("cancelMember").style.display="block";
	document.getElementById("demo3").innerHTML='<%=mem_cancel%>&#10004;';
}
window.onload=cancelledMemberStatus;
<%}%>

function returnBook()
{
	document.getElementById("addStudent").style.display="none";
	document.getElementById("addBook").style.display="none";
	document.getElementById("issueBook").style.display="none";
	document.getElementById("returnStatus").style.display="none";
	document.getElementById("cancelMember").style.display="none";
	document.getElementById("renewalMember").style.display="none";
	document.getElementById("returnBook").style.display="block";
}
<%if(return_status!=null&&obj!=null){%>
function returnBookStatus() {
	document.getElementById("returnStatus").style.display="block";
}
window.onload=returnBookStatus;
<%}%>
<%if(returned!=null){%>
function returnBookStatus() {
	document.getElementById("returnBook").style.display="block";
	document.getElementById("demo2").innerHTML='<%=returned%>';
}
window.onload=returnBookStatus;
<%}%>
function issueBook()
{
	document.getElementById("addStudent").style.display="none";
	document.getElementById("addBook").style.display="none";
	document.getElementById("returnBook").style.display="none";
	document.getElementById("returnStatus").style.display="none";
	document.getElementById("cancelMember").style.display="none";
	document.getElementById("renewalMember").style.display="none";
	document.getElementById("issueBook").style.display="block";
}
function bookIntry()
{
	document.getElementById("issueBook").style.display="none";
	document.getElementById("addStudent").style.display="none";
	document.getElementById("returnBook").style.display="none";
	document.getElementById("returnStatus").style.display="none";
	document.getElementById("cancelMember").style.display="none";
	document.getElementById("renewalMember").style.display="none";
	document.getElementById("addBook").style.display="block";
}

function addStudent()
{
	document.getElementById("issueBook").style.display="none";
	document.getElementById("addBook").style.display="none";
	document.getElementById("returnBook").style.display="none";
	document.getElementById("returnStatus").style.display="none";
	document.getElementById("cancelMember").style.display="none";
	document.getElementById("renewalMember").style.display="none";
	document.getElementById("addStudent").style.display="block";
}
function cancelMember()
{
	document.getElementById("issueBook").style.display="none";
	document.getElementById("addBook").style.display="none";
	document.getElementById("returnBook").style.display="none";
	document.getElementById("returnStatus").style.display="none";
	document.getElementById("addStudent").style.display="none";
	document.getElementById("renewalMember").style.display="none";
	document.getElementById("cancelMember").style.display="block";
}
function renewalMember()
{
	document.getElementById("issueBook").style.display="none";
	document.getElementById("addBook").style.display="none";
	document.getElementById("returnBook").style.display="none";
	document.getElementById("returnStatus").style.display="none";
	document.getElementById("addStudent").style.display="none";
	document.getElementById("cancelMember").style.display="none";
	document.getElementById("renewalMember").style.display="block";
}
function home()
{
	document.getElementById("issueBook").style.display="none";
	document.getElementById("addBook").style.display="none";
	document.getElementById("returnBook").style.display="none";
	document.getElementById("returnStatus").style.display="none";
	document.getElementById("addStudent").style.display="none";
	document.getElementById("cancelMember").style.display="none";
	document.getElementById("renewalMember").style.display="none";
	document.getElementById("membership-registration-stmt").style.display="none";
}
function resetFun1()
{
	var r=confirm("Want to RESET?");
	if(r==true)
		{
			document.getElementById("blocation").value="";
			document.getElementById("btitle").value="";
			document.getElementById("bauthor").value="";
			document.getElementById("bsubject").value="";
			document.getElementById("bkeyword").value="";
			document.getElementById("bc_no").value="";
			document.getElementById("bisbn").value="";
			document.getElementById("bedition").value="";
			document.getElementById("bpublisher").value="";
			document.getElementById("bp_year").value="";
		}
	
}

function resetFun2()
{
	var r=confirm("Want to RESET?");
	if(r==true)
		{
			document.getElementById("email").value="";
			document.getElementById("name").value="";
			document.getElementById("address").value="";
			document.getElementById("fee").value="";
			
		}
	
}

function mem_reg_stmt(x)
{
	document.getElementById("membership-registration-stmt").style.display="block";
	if(x==1)
	{
		document.getElementById("stmt-form").action = "mem_reg_stmt.jsp";
		document.getElementById("stmt-heading").innerHTML ="Membership Registration Statement";
	}
	if(x==2)
	{
		document.getElementById("stmt-form").action = "mem_renewal_stmt.jsp";
		document.getElementById("stmt-heading").innerHTML ="Membership Renewal Statement";
		
	}
	if(x==3)
	{
		document.getElementById("stmt-form").action = "mem_cancel_stmt.jsp";
		document.getElementById("stmt-heading").innerHTML ="Membership Cancellation Statement";
		
	}
	if(x==4)
	{
		document.getElementById("stmt-form").action = "fine_stmt.jsp";
		document.getElementById("stmt-heading").innerHTML ="Total Fine Collected Statement";
		
	}
}
<%if(mem_reg_stmt!=null){%>
function stmt_errorFun1() {
	document.getElementById("membership-registration-stmt").style.display="block";
	document.getElementById("error").innerHTML='<%=mem_reg_stmt%>';
	mem_reg_stmt(1);
}
window.onload=stmt_errorFun1;
<%}%>

<%if(mem_renewal_stmt!=null){%>
function stmt_errorFun2() {
	document.getElementById("membership-registration-stmt").style.display="block";
	document.getElementById("error").innerHTML='<%=mem_renewal_stmt%>';
	mem_reg_stmt(2);
}
window.onload=stmt_errorFun2;
<%}%>
<%if(mem_cancel_stmt!=null){%>
function stmt_errorFun3() {
	document.getElementById("membership-registration-stmt").style.display="block";
	document.getElementById("error").innerHTML='<%=mem_cancel_stmt%>';
	mem_reg_stmt(3);
}
window.onload=stmt_errorFun3;
<%}%>
<%if(fine_stmt!=null){%>
function stmt_errorFun4() {
	document.getElementById("membership-registration-stmt").style.display="block";
	document.getElementById("error").innerHTML='<%=fine_stmt%>';
	mem_reg_stmt(4);
}
window.onload=stmt_errorFun4;
<%}%>


</script>

</body>
</html>

