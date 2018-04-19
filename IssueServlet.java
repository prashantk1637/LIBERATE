/**
 * This servet is used to fetch details of 
 *the book selected from browse page
 *
 */




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
import javax.servlet.http.HttpSession;

import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.ResultSet;

/**
 * Servlet implementation class IssueServlet
 */
@WebServlet("/issue")
public class IssueServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public IssueServlet() {
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
		String userType=(String)s.getAttribute("userType");
		
		int accession_no=Integer.parseInt(request.getParameter("access"));
				PreparedStatement pstmt;
				String check_query="select accession_no from issue where accession_no=?";
		String sql="select accession_no,path,title,author,subject,edition,isbn,publisher,publication_year,keyword from books where accession_no=?";
		try{
				Class.forName("com.mysql.jdbc.Driver");  
				Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
				pstmt=(PreparedStatement) con.prepareStatement(check_query);
				pstmt.setInt(1,accession_no);
				ResultSet check=(ResultSet)pstmt.executeQuery();
				BookFullDetailsBean obj=new BookFullDetailsBean();
				if(check.next())
					obj.setAvailability("Not Available");
				
				else obj.setAvailability("Available");
				
				pstmt=(PreparedStatement) con.prepareStatement(sql);
				pstmt.setInt(1, accession_no);
				ResultSet rs=(ResultSet) pstmt.executeQuery();
				if(rs.next())
				{
						
					obj.setAccession_no(rs.getInt(1));
					obj.setPath(rs.getString(2));
					obj.setTitle(rs.getString(3));
					obj.setAuthor(rs.getString(4));
					obj.setSubject(rs.getString(5));
					obj.setEdition(rs.getString(6));
					obj.setIsbn(rs.getString(7));
					obj.setPublisher(rs.getString(8));
					obj.setPublication_year(rs.getInt(9));
					obj.setKeyword(rs.getString(10));
					//out.print("Keys"+obj.getKeyword());
					
					if(user!=null&&(userType.equals("student")||userType.equals("teacher")))
					{	HashSet<String> interest_set=new HashSet<>();
						String fetch_interest="select interest from userinterest where email=?";
						pstmt=(PreparedStatement) con.prepareStatement(fetch_interest);
						pstmt.setString(1, user);
						rs=(ResultSet) pstmt.executeQuery();
						if(rs.next())
						{	String interest=rs.getString(1)+obj.getKeyword()+":";
							String updated_interest=""; //without duplicate tags
							String tags[]=null;
							tags=interest.split(":");
							for(String str: tags)
								interest_set.add(str);
							for(String str: interest_set)
								updated_interest=updated_interest+str+":";
								
							String update_interest="UPDATE userinterest SET interest=? where email=?";
							pstmt=(PreparedStatement) con.prepareStatement(update_interest);
							pstmt.setString(1, updated_interest);
							pstmt.setString(2, user);
							pstmt.executeUpdate();
				
							
						}
						else
						{
							String insert="insert into userinterest values(?,?)";
							pstmt=(PreparedStatement) con.prepareStatement(insert);
							pstmt.setString(1, user);
							pstmt.setString(2, obj.getKeyword());
							
							pstmt.executeUpdate();
							
						}
					}
					
	
					
					request.setAttribute("OBJ", obj);
					RequestDispatcher rd=request.getRequestDispatcher("/bookForIssue.jsp");
					rd.forward(request, response);
						
					}
				
				
		con.close();		   
		}catch (Exception e) {
			// TODO: handle exception
		}
	}
}
	