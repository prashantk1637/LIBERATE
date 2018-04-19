/**
 * This Servlet is used to request a book for issue(if available) by member
 * and member will wait for approval by Librarian
 * 
 */



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
import com.mysql.jdbc.ResultSet;

/**
 * Servlet implementation class BookHistory
 */
@WebServlet("/history")
public class BookHistory extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookHistory() {
        super();
        // TODO Auto-generated constructor stub
    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		PrintWriter out=response.getWriter();
		HttpSession s=request.getSession(false);
		String user=(String)s.getAttribute("user");
		String userType=(String)s.getAttribute("userType");
		if(user==null)
			response.sendRedirect("/Liberate?error=login+first");
		
		
			int accession_no=Integer.parseInt(request.getParameter("accession_no"));
			String mem_id=request.getParameter("mem_id");
			String mem_type=request.getParameter("mem_type");
			String isbn=request.getParameter("isbn");
			String req_for_issue_date=request.getParameter("req_for_issue_date");
			String issue_approval="pending";
			String check_query="select accession_no from issue where isbn=? and mem_id=?";// checking book already issued or not..any copy of same book
			String sql= "insert into issue(accession_no,mem_id,mem_type,isbn,req_for_issue_date,issue_approval) values(?,?,?,?,?,?)";
			int MaxLimitflag=new CountNumberOfIssuedBooks().CountIssuedBook(user,userType);
			if(MaxLimitflag==0)
			{
				PreparedStatement pstmt;
				Connection con;
				try {
						Class.forName("com.mysql.jdbc.Driver");
						con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");
						pstmt=(PreparedStatement) con.prepareStatement(check_query);
					
					pstmt.setString(1,isbn);
					pstmt.setString(2, mem_id);
					ResultSet rs=(ResultSet)pstmt.executeQuery();
					if(rs.next()){
						response.sendRedirect("issue?access="+accession_no+"&status=Book+already+there");
						out.println(rs.getInt(1));
					}
					else{	
							pstmt=(PreparedStatement) con.prepareStatement(sql);
							pstmt.setInt(1,accession_no);
							pstmt.setString(2, mem_id);
							pstmt.setString(3, mem_type);
							pstmt.setString(4, isbn);
							pstmt.setString(5, req_for_issue_date);
							pstmt.setString(6, issue_approval);
							int flag=pstmt.executeUpdate();
							if(flag==1)
								response.sendRedirect("issue?access="+accession_no+"&status=Request for book issue has been made! Please go to library for approval");
							else
								response.sendRedirect("issue?access="+accession_no+"&status=error");
					}
					
					
					
				con.close();
				}catch (Exception e) {}
			}
			else if(MaxLimitflag==1)
					response.sendRedirect("issue?access="+accession_no+"&status=Maximum limit Reached!! You can't issue more book");
				

}
}
