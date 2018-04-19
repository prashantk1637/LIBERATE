/**This sevlet is used to display all books
 * stored in database(books table)
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

import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.ResultSet;

/**
 * Servlet implementation class BookCatalogServlet
 */
@WebServlet("/catalog")
public class BookCatalogServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookCatalogServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PreparedStatement pstmt;
		PrintWriter out=response.getWriter();
		String sql="select path,title,author,edition,isbn from books group by isbn";
		String sql1="select accession_no from books where isbn=?";
		try{
				Class.forName("com.mysql.jdbc.Driver");  
				Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
				pstmt=(PreparedStatement) con.prepareStatement(sql);
			ResultSet rs=(ResultSet) pstmt.executeQuery();
			ArrayList<BookDetailsBean> list=new ArrayList<>();
			while(rs.next())
			{
					BookDetailsBean obj=new BookDetailsBean();
					obj.setPath(rs.getString(1));
					obj.setTitle(rs.getString(2));
					obj.setAuthor(rs.getString(3));
					obj.setEdition(rs.getString(4));
					pstmt=(PreparedStatement) con.prepareStatement(sql1);
					pstmt.setString(1,rs.getString(5));
					ResultSet rs1=(ResultSet) pstmt.executeQuery();
					if(rs1.next())
					{
						obj.setAccession_no(rs1.getInt(1));
					}
					list.add(obj);
					
			}
			request.setAttribute("LIST", list);
			RequestDispatcher rd=request.getRequestDispatcher("/bookcatalog.jsp");
			rd.forward(request, response);
			
		con.close();
		}catch (Exception e) {
			// TODO: handle exception
		}
}
}
