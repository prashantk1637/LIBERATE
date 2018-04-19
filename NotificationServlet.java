package com.liberate;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mysql.jdbc.PreparedStatement;

/**
 * Servlet implementation class NotificationServlet
 */
@WebServlet("/notification")
public class NotificationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NotificationServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String mem_id=request.getParameter("mem_id");
		String notification=request.getParameter("notification");
		String due_date=request.getParameter("due_date");
		String notification_date=request.getParameter("notification_date");
		String flagStr=request.getParameter("flag");
		String sql="insert into notification(mem_id,notification,due_date,notification_date,catchup) values(?,?,?,?,?)";
		try{
			Class.forName("com.mysql.jdbc.Driver");  
			Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
			PreparedStatement pstmt=(PreparedStatement) con.prepareStatement(sql);
			pstmt.setString(1, mem_id);
			pstmt.setString(2, notification);
			pstmt.setString(3,due_date);
			pstmt.setString(4, notification_date);
			pstmt.setString(5, "NO");
			int flag=pstmt.executeUpdate();
			if(flag==1)
			{
				
				request.setAttribute("mem_id", mem_id);
				request.setAttribute("notification",notification);
				if(flagStr.equals("bookdue"))
				{
					RequestDispatcher rd=request.getRequestDispatcher("/bookDueFromMember.jsp");
					rd.forward(request, response);
				}
				else if(flagStr.equals("memberdue"))
				{
					RequestDispatcher rd=request.getRequestDispatcher("/membershipRenewalDue.jsp");
					rd.forward(request, response);
				}
			}

		}catch (Exception e) {}
	}

}
