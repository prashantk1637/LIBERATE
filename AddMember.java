/**
 * This servet is used for member registration 
 *(Used by Librarian)
 */

package com.liberate;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.mysql.jdbc.PreparedStatement;

/**
 * Servlet implementation class AddMember
 */
@WebServlet("/addmember")
public class AddMember extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddMember() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out=response.getWriter();
		HttpSession s=request.getSession(false);
		String user=(String)s.getAttribute("user");
		if(user==null)
			response.sendRedirect("/Liberate?error=Login+first");
		DateFormat df=new SimpleDateFormat("dd/MM/yyyy");
		Date d=new Date();
		
		String email=request.getParameter("email");
		String pass=request.getParameter("pass");
		String name=request.getParameter("name");
		String day=request.getParameter("day");
		String month=request.getParameter("month");
		String year=request.getParameter("year");
		String dob=day+"/"+month+"/"+year;
		String gender=request.getParameter("gender");
		String address=request.getParameter("address");
		String usertype=request.getParameter("usertype");
		String regdate=request.getParameter("r_date");
		String feeDeposit=request.getParameter("feedeposit");
		int fee=Integer.parseInt(feeDeposit);
		int days=fee/2;
		Calendar cal = Calendar.getInstance();    
		try{cal.setTime( df.parse(regdate)); }catch (Exception e) {	}   
		cal.add( Calendar.DATE,days);    
		String expiredate=df.format(cal.getTime());
		String sql= "insert into member values(?,?,?,?,?,?,?,?,?,?)";
		PreparedStatement pstmt;
		Connection con;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");
			pstmt=(PreparedStatement) con.prepareStatement(sql);
			pstmt.setString(1, email);
			pstmt.setString(2, pass);
			pstmt.setString(3, name);
			pstmt.setString(4, dob);
			pstmt.setString(5, gender);
			pstmt.setString(6, address);
			pstmt.setString(7, usertype);
			pstmt.setString(8, regdate);
			pstmt.setString(9, expiredate);
			pstmt.setInt(10, fee);
			int flag=pstmt.executeUpdate();
			
			if(flag==1){
				String sql1= "insert into login values(?,?,?)";
				PreparedStatement pstmt1=(PreparedStatement) con.prepareStatement(sql1);
				pstmt1.setString(1, email);
				pstmt1.setString(2, pass);
				pstmt1.setString(3, usertype);
				pstmt1.executeUpdate();
						response.sendRedirect("librarian.jsp?mem_add=Successful");
			
			}
			else
				response.sendRedirect("librarian.jsp?mem_add=ERROR");
	 con.close();
	}catch (Exception e) {
		
	}

}
}