package com.liberate;

import java.sql.Connection;
import java.sql.DriverManager;

import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.ResultSet;

public class CountNumberOfIssuedBooks {
	public int CountIssuedBook(String mem_id,String mem_type)
	{
	String sql="select count(*) from issue where mem_id=?";
	try{
		Class.forName("com.mysql.jdbc.Driver");  
		Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
		PreparedStatement pstmt=(PreparedStatement) con.prepareStatement(sql);
		pstmt.setString(1, mem_id);
		ResultSet rs=(ResultSet) pstmt.executeQuery();
		if(rs.next())
		{
			if(mem_type.equals("student"))
			{
				if(rs.getInt(1)<4)
					return 0;
				else if(rs.getInt(1)==4)
					return 1;

			}
			if(mem_type.equals("teacher"))
			{
				if(rs.getInt(1)<5)
					return 0;
				else if(rs.getInt(1)==5)
					return 1;

			}
		}
		
	
		}catch (Exception e) {}
	return 0;
	}

}
