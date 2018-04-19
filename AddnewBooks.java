/**
 * This servet is used to new Book Entry
 *(Used by Librarian)
 */



package com.liberate;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.mysql.jdbc.PreparedStatement;

/**
 * Servlet implementation class AddnewBooks
 */
@WebServlet("/addbooks")
public class AddnewBooks extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddnewBooks() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession s=request.getSession(false);
		String user=(String)s.getAttribute("user");
		PrintWriter out=response.getWriter();
		if(user==null)
			response.sendRedirect("/Liberate?error=Login+first");
		
		String path=request.getParameter("path");
		String title=request.getParameter("title");
		String author=request.getParameter("author");
		String subject=request.getParameter("subject");
		String keyword=request.getParameter("keyword");
		String classification_no=request.getParameter("c_no");
		String isbn=request.getParameter("isbn");
		String edition=request.getParameter("edition");
		String publisher=request.getParameter("publisher");
		int publication_year=Integer.parseInt(request.getParameter("p_year"));
		String sql= "insert into books(path,title,author,subject,keyword,classfication_no,isbn,edition,publisher,publication_year) values(?,?,?,?,?,?,?,?,?,?)";
		PreparedStatement pstmt;
		Connection con;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");
			pstmt=(PreparedStatement) con.prepareStatement(sql);
			pstmt.setString(1,path);
			pstmt.setString(2,title);
			pstmt.setString(3,author);
			pstmt.setString(4,subject);
			pstmt.setString(5,keyword);
			pstmt.setString(6,classification_no);
			pstmt.setString(7,isbn);
			pstmt.setString(8,edition);
			pstmt.setString(9,publisher);
			pstmt.setInt(10,publication_year);
			int flag=pstmt.executeUpdate();
			if(flag==1)
			{	//inserting some details of same book in search table for search operation
				String check="select isbn_no from stdsearch where isbn_no=?";
				PreparedStatement pstmt1=(PreparedStatement) con.prepareStatement(check);
				pstmt1.setString(1, isbn);
				ResultSet rs=(ResultSet)pstmt1.executeQuery();
				if(rs.next()){ /*if exist then don't insert*/ }
				else{
					String sql1= "insert into stdsearch(title,author,keyword,isbn_no) values(?,?,?,?)";
					pstmt1=(PreparedStatement) con.prepareStatement(sql1);
					pstmt1.setString(1, title.toLowerCase());
					pstmt1.setString(2, author.toLowerCase());
					pstmt1.setString(3,keyword.toLowerCase());
					pstmt1.setString(4, isbn);
					pstmt1.executeUpdate();
				}
				//inserting book isbn and keywords(tags) into book_tag table for showing relevant books to user
				check="select isbn from book_tag where isbn=?";
				pstmt1=(PreparedStatement) con.prepareStatement(check);
				pstmt1.setString(1, isbn);
				rs=(ResultSet)pstmt1.executeQuery();
				if(rs.next()){ /*if exist then don't insert*/ }
				else{
					String sql2="insert into book_tag values(?,?)";
					pstmt1=(PreparedStatement) con.prepareStatement(sql2);
					pstmt1.setString(1, isbn);
					pstmt1.setString(2, keyword.toLowerCase());
					pstmt1.executeUpdate();
					
					}
			response.sendRedirect("librarian.jsp?insert=Successful");	
			}
			else
				response.sendRedirect("librarian.jsp?insert=ERROR");
			
			
			con.close();	
		} catch (Exception e) {	}  
		
	}

}
