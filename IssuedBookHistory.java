/**
 * This Servlet is used to fetch(view) all the issued books by member
 * The issue approval status may be pending or issued
 * 
 * 
 * 
 * 
 */

package com.liberate;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.ResultSet;

/**
 * Servlet implementation class IssuedBookHistory
 */
@WebServlet("/issuedDetails")
public class IssuedBookHistory extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public IssuedBookHistory() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out=response.getWriter();
		HttpSession s=request.getSession(false);
		String user=(String)s.getAttribute("user");
		ArrayList<IssuedBookedDetailsBean> list=new ArrayList<>();
		PreparedStatement pstmt;
		String sql="select accession_no,req_for_issue_date,issue_date,return_date, issue_approval from issue where mem_id=?";
		try{
				Class.forName("com.mysql.jdbc.Driver");  
				Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
				pstmt=(PreparedStatement) con.prepareStatement(sql);
				pstmt.setString(1, user);
				ResultSet rs=(ResultSet) pstmt.executeQuery();
				while(rs.next())
				{	
					String sql1="select path,title,author,subject,edition,isbn,publisher,publication_year from books where accession_no=?";
					pstmt=(PreparedStatement) con.prepareStatement(sql1);
					pstmt.setInt(1,rs.getInt(1));
					ResultSet rs1=(ResultSet) pstmt.executeQuery();
					if(rs1.next())
					{
						IssuedBookedDetailsBean obj=new IssuedBookedDetailsBean();
						obj.setAccession_no(rs.getInt(1));
						obj.setReq_for_issue_date(rs.getString(2));
						obj.setIssue_date(rs.getString(3));
						obj.setReturn_date(rs.getString(4));
						obj.setIssue_approval(rs.getString(5));
						obj.setPath(rs1.getString(1));
						obj.setTitle(rs1.getString(2));
						obj.setAuthor(rs1.getString(3));
						obj.setSubject(rs1.getString(4));
						obj.setEdition(rs1.getString(5));
						obj.setIsbn(rs1.getString(6));
						obj.setPublisher(rs1.getString(7));
						obj.setPublication_year(rs1.getInt(8));
						list.add(obj);
					}
				}
			request.setAttribute("LIST",list);
			RequestDispatcher rd=request.getRequestDispatcher("/displayIssuedBooks.jsp");
			rd.forward(request, response);
				
		con.close();
		}catch (Exception e) {
			
		}
	
	}

}
