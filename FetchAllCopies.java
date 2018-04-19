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
 * Servlet implementation class FetchAllCopies
 */
@WebServlet("/allcopies")
public class FetchAllCopies extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public FetchAllCopies() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession s=request.getSession(false);
		String user=(String)s.getAttribute("user");
		if(user==null)
			response.sendRedirect("/Liberate?error=login+first");
		String isbn=request.getParameter("isbn");
		String sql="select accession_no,title,author,edition,isbn from books where isbn=?";
		String sql1="select issue_approval from issue where accession_no=?";
		PrintWriter out=response.getWriter();
		PreparedStatement pstmt;
		try{
				Class.forName("com.mysql.jdbc.Driver");  
				Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
				pstmt=(PreparedStatement) con.prepareStatement(sql);
				pstmt.setString(1, isbn);
				ResultSet rs=(ResultSet) pstmt.executeQuery();
				ArrayList<AllCopiesOfAbookBean> list=new ArrayList<>();
				while(rs.next())
				{
					pstmt=(PreparedStatement) con.prepareStatement(sql1);
					pstmt.setInt(1,rs.getInt(1));
					ResultSet rs1=(ResultSet)pstmt.executeQuery();
					AllCopiesOfAbookBean obj=new AllCopiesOfAbookBean();
					obj.setAccession_no(rs.getInt(1));
					obj.setTitle(rs.getString(2));
					obj.setAuthor(rs.getString(3));
					obj.setEdition(rs.getString(4));
					obj.setIsbn(rs.getString(5));
					if(rs1.next())
							obj.setStatus("Issued");
				
					else obj.setStatus("Available");
					list.add(obj);
				}
				request.setAttribute("LIST", list);
				RequestDispatcher rd=request.getRequestDispatcher("/allCopiesOfAbook.jsp");
				rd.forward(request, response);
				
		con.close();		
		}catch (Exception e) {
			// TODO: handle exception
		}
	}

}
