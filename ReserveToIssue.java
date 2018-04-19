package com.liberate;

import java.sql.DriverManager;

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.PreparedStatement;

public class ReserveToIssue {

	public int insertToIssue(int accession_no, String mem_id,String mem_type,String isbn,String req_for_issue_date, String issue_approval)
	{
		int flag=0;	
		String sql= "insert into issue(accession_no,mem_id,mem_type,isbn,req_for_issue_date,issue_approval) values(?,?,?,?,?,?)";
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con=(Connection) DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");
			PreparedStatement pstmt=(PreparedStatement) con.prepareStatement(sql);
			pstmt=(PreparedStatement) con.prepareStatement(sql);
			pstmt.setInt(1,accession_no);
			pstmt.setString(2, mem_id);
			pstmt.setString(3, mem_type);
			pstmt.setString(4, isbn);
			pstmt.setString(5, req_for_issue_date);
			pstmt.setString(6, issue_approval);
			flag=pstmt.executeUpdate();
			//System.out.println("Flag="+flag);
			
		} catch (Exception e) {}
		
		
		
		return flag;
	}
	
	
}
