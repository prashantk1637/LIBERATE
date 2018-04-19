package com.liberate;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.HashSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.ResultSet;

/**
 * Servlet implementation class IsbnSearch
 */
@WebServlet("/isbnSearch")
public class IsbnSearch extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public IsbnSearch() {
        super();
        // TODO Auto-generated constructor stub
    }
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out=response.getWriter();
		String isbn=request.getParameter("isbn");
		isbn=isbn.replace("-","");
		isbn=isbn.replace(" ","");
		HashSet<String> isbn_set=new HashSet<>();
		HashSet<String> relevant_isbn_set=new HashSet<>();
		String sql="select isbn_no from stdsearch";
		try {
				Class.forName("com.mysql.jdbc.Driver");
				Connection con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");
				PreparedStatement pstmt=con.prepareStatement(sql);
				ResultSet rs=(ResultSet)pstmt.executeQuery();
				while(rs.next())
				{
					if(rs.getString(1).replace("-", "").equals(isbn))
					{
						isbn_set.add(rs.getString(1));
						
						break;
					}
				}
			}catch (Exception e) {}
		
		request.setAttribute("ISBN_LIST",isbn_set);
		request.setAttribute("RELEVANT_ISBN_LIST",relevant_isbn_set);
		RequestDispatcher rd=request.getRequestDispatcher("/stdresult");
		rd.forward(request, response);
	}

}
