/**
 * This servlet is used by Member
 * to check weather requested book for return 
 * is returned or not.
 * 
 * 
 * 
 * 
 */



package com.liberate;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

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
 * Servlet implementation class ReturnStatusShownByMember
 */
@WebServlet("/returnStatus")
public class ReturnStatusShownByMember extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ReturnStatusShownByMember() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession s=request.getSession(false);
		String user=(String)s.getAttribute("user");
		if(user==null)
			response.sendRedirect("/Liberate?error=Login+first");
			PreparedStatement pstmt;
			String sql="select accession_no,mem_id,mem_type,librarian_id,issue_date,due_date,return_date,fine_paid,return_approval from returned where mem_id=?";
			try{
					Class.forName("com.mysql.jdbc.Driver");  
					Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
					pstmt=(PreparedStatement) con.prepareStatement(sql);
					pstmt.setString(1, user);
					ResultSet rs=(ResultSet)pstmt.executeQuery();
					ArrayList<ReturnStatusBean> list=new ArrayList<>();
					while(rs.next())
					{
						ReturnStatusBean obj=new ReturnStatusBean();
						obj.setAccession_no(rs.getInt(1));
						obj.setMem_id(rs.getString(2));
						obj.setMem_type(rs.getString(3));
						obj.setLibrarian_id(rs.getString(4));
						obj.setIssue_date(rs.getString(5));
						obj.setDue_date(rs.getString(6));
						obj.setReturn_date(rs.getString(7));
						obj.setFine_paid(rs.getInt(8));
						obj.setReturned_approval(rs.getString(9));
						list.add(obj);
					}
					request.setAttribute("LIST",list);
					RequestDispatcher rd=request.getRequestDispatcher("/showReturnedbooks.jsp");
					rd.forward(request, response);
							
					
					
			con.close();			
			}catch (Exception e) {
				// TODO: handle exception
			}

}
}
