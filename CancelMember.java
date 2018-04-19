package com.liberate;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.mysql.jdbc.PreparedStatement;

/**
 * Servlet implementation class CancelMember
 */
@WebServlet("/cancelMember")
public class CancelMember extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CancelMember() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession s=request.getSession(false);
		String user=(String)s.getAttribute("user");
		PrintWriter out=response.getWriter();
		if(user==null)
			response.sendRedirect("/Liberate?error=Login+first");
		
		String mem_id=request.getParameter("mem_id");
		String mem_name=request.getParameter("mem_name");
		String lib_id=request.getParameter("lib_id");
		String cancel_date=request.getParameter("cancel_date");
		String amount=request.getParameter("amount");
		int amt=Integer.valueOf(amount);
		String due_refund=request.getParameter("due_refund");
			PreparedStatement pstmt;
			String sql="delete from member where email=?";
			String sql1="delete from login where email=?";
			String sql2="delete from issue where mem_id=? and issue_approval=?";
			String sql3="insert into cancelledmember values(?,?,?,?,?,?)";
		
			try{
					Class.forName("com.mysql.jdbc.Driver");  
					Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
					pstmt=(PreparedStatement) con.prepareStatement(sql);
					pstmt.setString(1, mem_id);
					int flag=pstmt.executeUpdate();
					
					if(flag==1)
					{
						pstmt=(PreparedStatement) con.prepareStatement(sql1);
						pstmt.setString(1, mem_id);
						pstmt.executeUpdate();
						pstmt=(PreparedStatement) con.prepareStatement(sql2);
						pstmt.setString(1, mem_id);
						pstmt.setString(2,"pending");
						pstmt.executeUpdate();
						pstmt=(PreparedStatement) con.prepareStatement(sql3);
						pstmt.setString(1, mem_id);
						pstmt.setString(2, mem_name);
						pstmt.setString(3, lib_id);
						pstmt.setString(4, cancel_date);
						pstmt.setInt(5, amt);
						pstmt.setString(6, due_refund);
						pstmt.executeUpdate();
						response.sendRedirect("librarian.jsp?mem_cancel=successful");
						
					}
					
					
			}catch (Exception e) {}
	}

}
