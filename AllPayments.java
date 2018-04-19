package com.liberate;

import java.sql.Connection;
import java.sql.DriverManager;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.ResultSet;

public class AllPayments {
	
	public ArrayList<AllPaymemtsBean> getAllPayemt(String mem_id)
	{
		ArrayList<AllPaymemtsBean> payment_list=new ArrayList<>();
		
	try{
		
		PreparedStatement pstmt;
		String sql="select amount,payment_date from payment where mem_id=?";
		Class.forName("com.mysql.jdbc.Driver");  
		Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
		pstmt=(PreparedStatement) con.prepareStatement(sql);
		pstmt.setString(1,mem_id);
		ResultSet rs=(ResultSet) pstmt.executeQuery();
		while(rs.next())
		{
			AllPaymemtsBean obj=new AllPaymemtsBean();
			obj.setAmount(rs.getInt(1));
			obj.setPaymemt_date(rs.getString(2));
			payment_list.add(obj);
			
		}
		
	}catch (Exception e) {}
 
return payment_list;	
}


}
