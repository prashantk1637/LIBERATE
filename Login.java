package com.liberate;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.ResultSet;

import recommendation.ItemSimilarity;
import recommendation.UserSimilarity;

/**
 * Servlet implementation class login
 */
@WebServlet("/login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Login() {
        super();
        // TODO Auto-generated constructor stub
    }
    

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String user =request.getParameter("user");
		String pass=request.getParameter("pass");
		PreparedStatement pstmt;	
		String sql="select email,password,mem_type from login where email=? and password=?";
		try{
				Class.forName("com.mysql.jdbc.Driver");  
				Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
				pstmt=(PreparedStatement) con.prepareStatement(sql);
				pstmt.setString(1,user);
				pstmt.setString(2,pass);
				//PrintWriter out=response.getWriter();
			ResultSet rs=(ResultSet) pstmt.executeQuery();
			if(rs.next())
			{	HttpSession s=request.getSession(true);
			
				
				if(rs.getString(1).equals(user)&& rs.getString(2).equals(pass)&&rs.getString(3).equals("librarian"))
				{
					s.setAttribute("user",rs.getString(1));
					s.setAttribute("userType","librarian");
					ItemSimilarity IS=new ItemSimilarity();
					IS.start();// using another thread for calculating Item similarity
					
					RequestDispatcher rd=request.getRequestDispatcher("/librarian.jsp");
					rd.forward(request, response);
					
				}
				else if(rs.getString(3).equals("student"))
				{	
					s.setAttribute("user",rs.getString(1));
					s.setAttribute("userType","student");
					UserSimilarity us=new UserSimilarity();
					us.start();// using another thread for calculating user similarity
					RequestDispatcher rd=request.getRequestDispatcher("/member.jsp");
					rd.forward(request, response);
				}
				else if( rs.getString(3).equals("teacher"))
				{
					s.setAttribute("user",rs.getString(1));
					s.setAttribute("userType","teacher");
					UserSimilarity us=new UserSimilarity();
					us.start();// using another thread for calculating user similarity
					RequestDispatcher rd=request.getRequestDispatcher("/member.jsp");
					rd.forward(request, response);
				
				}
				
			}
			else
			{
				sql="select mem_id from cancelledMember where mem_id=?";
				pstmt=(PreparedStatement) con.prepareStatement(sql);
				pstmt.setString(1,user);
				rs=(ResultSet) pstmt.executeQuery();
				if(rs.next())
				{
					response.sendRedirect("/Liberate?error=Membership has been cancelled");
				}
				else response.sendRedirect("/Liberate?error=wrong+credentials");
					
				
				
				
				
			}
				
			
				
		con.close();
		}catch (Exception e) {
		
		}
	
	}

}
