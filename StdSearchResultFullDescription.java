package com.liberate;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.HashSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.ResultSet;

/**
 * Servlet implementation class StdSearchResultFullDescription
 */
@WebServlet("/stdresult")
public class StdSearchResultFullDescription extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public StdSearchResultFullDescription() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PreparedStatement pstmt,pstmt1;
		PrintWriter out=response.getWriter();
		Object isbn_obj=request.getAttribute("ISBN_LIST");
		Object relevant_isbn_obj=request.getAttribute("RELEVANT_ISBN_LIST");
		HashSet<String> isbn_list=(HashSet<String>)isbn_obj;
		HashSet<String> relevant_isbn_list=(HashSet<String>)relevant_isbn_obj;
		String sql="select path,title,author,edition,isbn from books where isbn=?";
		String sql1="select accession_no from books where isbn=?";
		try{
				Class.forName("com.mysql.jdbc.Driver");  
				Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
				pstmt=(PreparedStatement) con.prepareStatement(sql);
				ArrayList<BookDetailsBean> main_list=new ArrayList<>();
				ArrayList<BookDetailsBean> relevant_list=new ArrayList<>();
				for(String isbn: isbn_list)
				{
					pstmt.setString(1, isbn);
					ResultSet rs=(ResultSet) pstmt.executeQuery();
					BookDetailsBean obj=new BookDetailsBean();
					if(rs.next())
					{
						
						obj.setPath(rs.getString(1));
						obj.setTitle(rs.getString(2));
						obj.setAuthor(rs.getString(3));
						obj.setEdition(rs.getString(4));
						pstmt1=(PreparedStatement) con.prepareStatement(sql1);
						pstmt1.setString(1,rs.getString(5));
						ResultSet rs1=(ResultSet) pstmt1.executeQuery();
						if(rs1.next())
						{
							obj.setAccession_no(rs1.getInt(1));
						}
						
					}
					main_list.add(obj);
				}
				for(String isbn: relevant_isbn_list)
				{
					pstmt.setString(1, isbn);
					ResultSet rs=(ResultSet) pstmt.executeQuery();
					BookDetailsBean obj=new BookDetailsBean();
					if(rs.next())
					{
						
						obj.setPath(rs.getString(1));
						obj.setTitle(rs.getString(2));
						obj.setAuthor(rs.getString(3));
						obj.setEdition(rs.getString(4));
						pstmt1=(PreparedStatement) con.prepareStatement(sql1);
						pstmt1.setString(1,rs.getString(5));
						ResultSet rs1=(ResultSet) pstmt1.executeQuery();
						if(rs1.next())
						{
							obj.setAccession_no(rs1.getInt(1));
						}
						
					}
					relevant_list.add(obj);
				}
				request.setAttribute("MAIN_LIST", main_list);
			request.setAttribute("RELEVANT_LIST", relevant_list);
			RequestDispatcher rd=request.getRequestDispatcher("/searchResult.jsp");
			rd.forward(request, response);
			
		con.close();	
		}catch (Exception e) {
			// TODO: handle exception
		}
	
  }
}
