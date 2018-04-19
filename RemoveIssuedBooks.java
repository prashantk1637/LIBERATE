package com.liberate;

import java.io.IOException;
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
 * Servlet implementation class RemoveIssuedBooks
 */
@WebServlet("/remove")
public class RemoveIssuedBooks extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RemoveIssuedBooks() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession s=request.getSession(false);
		String user=(String)s.getAttribute("user");
		String mem_id=request.getParameter("mem_id");
		if(user==null)
			response.sendRedirect("/Liberate?error=Login+first");
		String sql= "delete from issue where mem_id=?";
		PreparedStatement pstmt;
		Connection con;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");
			pstmt=(PreparedStatement) con.prepareStatement(sql);
			pstmt.setString(1, mem_id);
			int flag=pstmt.executeUpdate();
			if(flag>0)
				response.sendRedirect("cancelMember.jsp?mem_id="+mem_id);
			
		}catch (Exception e) {
			// TODO: handle exception
		}
	}

}
