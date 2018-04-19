package com.liberate;

import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import com.mysql.jdbc.Connection;

public class AutomaticBookDueNotification {
	public void notification(){
	SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
 	SimpleDateFormat df1 = new SimpleDateFormat("yyyy-MM-dd");
	Date d=new Date();
 	String today=df.format(d);
 	String title=null,author=null;
 	String notification=null,due_date=null,mem_id=null;
	PreparedStatement pstmt=null;
	String sql="select accession_no, mem_id, return_date from issue where issue_approval=?";
	try{
			Class.forName("com.mysql.jdbc.Driver");  
			Connection con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
			
			pstmt=(PreparedStatement) con.prepareStatement(sql);
			pstmt.setString(1, "issued");
			ResultSet rs=(ResultSet) pstmt.executeQuery();
			while(rs.next())
			{
				mem_id=rs.getString(2);
				due_date=rs.getString(3);
				String sql1="select title,author from books where accession_no=?";
				pstmt=(PreparedStatement) con.prepareStatement(sql1);
				pstmt.setInt(1,rs.getInt(1));
				ResultSet rs1=(ResultSet) pstmt.executeQuery();
				if(rs1.next())
				{	title=rs1.getString(1);
					author=rs1.getString(2);
					notification="Due book titled: "+title+" by "+author;
					
					Date date1 = df.parse(due_date);
				 	String due_date1=df1.format(date1);
					Date td=df.parse(today);
					String tday=df1.format(td);
					Calendar cal1 = Calendar.getInstance();
		            Calendar cal2 = Calendar.getInstance();
		            cal1.setTime(date1);
		            cal2.setTime(td);
		            cal2.add(Calendar.DATE, 3);
		            if(cal1.equals(cal2))
					{	
						sql="insert into notification(mem_id,notification,due_date,notification_date,catchup) values(?,?,?,?,?)";
						pstmt=(PreparedStatement) con.prepareStatement(sql);
						pstmt.setString(1, mem_id);
						pstmt.setString(2, notification);
						
						pstmt.setString(3,due_date);
						pstmt.setString(4, today);// notification date
						pstmt.setString(5, "NO");
						int flag=pstmt.executeUpdate();
					}
				}
			}
		con.close();
		}catch (Exception e) {}
	}
}
