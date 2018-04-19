<!DOCTYPE html>
<%@page import="com.mysql.jdbc.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="com.mysql.jdbc.Connection"%>
<%@page import="java.sql.ResultSet"%>
<html>
<head>
<meta charset="ISO-8859-1">
<style type="text/css">
li{
list-style:square;

}
</style>
</head>
<%
String sql="select notice,notice_date,notice_link from notice";
PreparedStatement pstmt;
Connection con;
try {	
			Class.forName("com.mysql.jdbc.Driver");
			con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");
			pstmt=(PreparedStatement) con.prepareStatement(sql);
			ResultSet rs=pstmt.executeQuery();
			while(rs.next())
			{%>
			<ul>
			<li><%=rs.getString(1) %><%if(rs.getString(3)!=null){%><a href='<%=rs.getString(3)%>' target="_blank">click</a><%}%>&nbsp;&nbsp;&nbsp;<span style="font-size: 12px;"><i><%=rs.getString(2)%></i></span></li>
			
						
		</ul>
			
				
  			<%}
	}catch(Exception e){}



%>
</html>