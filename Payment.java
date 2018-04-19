package com.liberate;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mysql.jdbc.PreparedStatement;

/**
 * Servlet implementation class Payment
 */
@WebServlet("/payment")
public class Payment extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Payment() {
        super();
        // TODO Auto-generated constructor stub
    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String pay=request.getParameter("payment");
		int payment=Integer.valueOf(pay);
		String mem_id=request.getParameter("mem_id");
		String lib_id=request.getParameter("lib_id");
		String payment_date=request.getParameter("payment_date");
		String renewal_date=request.getParameter("renewal_date");
		PreparedStatement pstmt;
		String sql0="update member set expiry_date=? where email=?";
		String sql1="insert into payment(amount,mem_id,librarian_id,payment_date) values(?,?,?,?)";
	
		try{
				DateFormat df=new SimpleDateFormat("dd/MM/yyyy");
				Calendar cal = Calendar.getInstance();    
				cal.setTime( df.parse(renewal_date));    
				cal.add( Calendar.DATE, payment/2 );    
				String updated_renewal_date=df.format(cal.getTime());
			
				Class.forName("com.mysql.jdbc.Driver");  
				Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
				pstmt=(PreparedStatement) con.prepareStatement(sql0);
				pstmt.setString(1,updated_renewal_date);
				pstmt.setString(2, mem_id);
				pstmt.executeUpdate();
				pstmt=(PreparedStatement) con.prepareStatement(sql1);
				pstmt.setInt(1, payment);
				pstmt.setString(2, mem_id);
				pstmt.setString(3, lib_id);
				pstmt.setString(4, payment_date);
				int flag=pstmt.executeUpdate();
				if(flag==1)
				{
					request.setAttribute("mem_id", mem_id);
					request.setAttribute("payment_status","success");
					RequestDispatcher rd=request.getRequestDispatcher("renewalMember.jsp");
					rd.forward(request, response);
					
							
				}
				
		}catch (Exception e) {
			// TODO: handle exception
		}
	}

}
