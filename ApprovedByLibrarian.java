/**This servlet is used by Librarian to fetch the
 * Member's issued book after doing approval of book
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
 * Servlet implementation class ApprovedByLibrarian
 */
@WebServlet("/approved")
public class ApprovedByLibrarian extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ApprovedByLibrarian() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int accession_no=Integer.parseInt(request.getParameter("accession_no"));
		String isbn=request.getParameter("isbn");
		String mem_id=request.getParameter("mem_id");
		String issue_date=request.getParameter("issue_date");
		String return_date=request.getParameter("return_date");
		String issue_approval=request.getParameter("issue_approval");
		issue_approval="issued";
		HttpSession s=request.getSession(false);
		String user=(String)s.getAttribute("user");
		PreparedStatement pstmt;
		String update="UPDATE issue SET librarian_id=? ,issue_date=?,return_date=?, issue_approval=? where accession_no=? and mem_id=?";
		try{
				Class.forName("com.mysql.jdbc.Driver");  
				Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
				pstmt=(PreparedStatement) con.prepareStatement(update);
				pstmt.setString(1, user);
				pstmt.setString(2, issue_date);
				pstmt.setString(3, return_date);
				pstmt.setString(4, issue_approval);
				pstmt.setInt(5, accession_no);
				pstmt.setString(6,mem_id);
				int flag=pstmt.executeUpdate();
				if(flag==1)
				{	
					update="delete from reserve where accession_no=?";
					pstmt=(PreparedStatement) con.prepareStatement(update);
					pstmt.setInt(1, accession_no);
					pstmt.executeUpdate();
					String insert_issuelog="insert into issue_log(mem_id,issue_date,isbn) values(?,?,?)";
					pstmt=(PreparedStatement) con.prepareStatement(insert_issuelog);
					pstmt.setString(1,mem_id);
					pstmt.setString(2,issue_date);
					pstmt.setString(3, isbn);
					pstmt.executeUpdate();
				}
				recommendation.PopularBooks p=new recommendation.PopularBooks();
				p.insertPopularBook(accession_no, isbn, mem_id);
				String sql="select accession_no,mem_id,req_for_issue_date,issue_date,return_date, issue_approval from issue where mem_id=?";
				pstmt=(PreparedStatement) con.prepareStatement(sql);
				pstmt.setString(1, mem_id);
				ResultSet rs=(ResultSet) pstmt.executeQuery();
				ArrayList<IssuedBookedDetailsBean> list=new ArrayList<>();
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
						obj.setMem_id(rs.getString(2));
						obj.setReq_for_issue_date(rs.getString(3));
						obj.setIssue_date(rs.getString(4));
						obj.setReturn_date(rs.getString(5));
						obj.setIssue_approval(rs.getString(6));
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
			// TODO: handle exception
		}
		
	}

}
