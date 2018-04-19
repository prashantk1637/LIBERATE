package com.liberate;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.ResultSet;

/**
 * Servlet implementation class ReserveBookServlet
 */
@WebServlet("/reserve")
public class ReserveBookServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ReserveBookServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int accession_no=Integer.parseInt(request.getParameter("accession_no"));
		
		String mem_id=request.getParameter("mem_id");
		String mem_type=request.getParameter("mem_type");
		String isbn=request.getParameter("isbn");
		String reserve_date=request.getParameter("reserve_date");
		String check_query="select accession_no from reserve where mem_id=? and isbn=?";
		String check_query1="select accession_no from issue where mem_id=? and isbn=?";
		String sql= "insert into reserve(accession_no,mem_id,mem_type,isbn,reserve_date) values(?,?,?,?,?)";
		PreparedStatement chkpstmt,pstmt;
		Connection con;
		try {
				Class.forName("com.mysql.jdbc.Driver");
				con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");
				chkpstmt=(PreparedStatement) con.prepareStatement(check_query1);
				chkpstmt.setString(1, mem_id);
				chkpstmt.setString(2,isbn);
				ResultSet rs=(ResultSet)chkpstmt.executeQuery();
				if(rs.next()){
					response.sendRedirect("issue?access="+accession_no+"&status=STOP! +Already+a+copy+Issued");
				}
				else{
				
					chkpstmt=(PreparedStatement) con.prepareStatement(check_query);
					
					chkpstmt.setString(1, mem_id);
					chkpstmt.setString(2,isbn);
					rs=(ResultSet)chkpstmt.executeQuery();
					if(rs.next()){
						response.sendRedirect("issue?access="+accession_no+"&status=STOP! +Already+a+copy+Reserved");
					}
					else{
						pstmt=(PreparedStatement) con.prepareStatement(sql);
						pstmt.setInt(1, accession_no);
						pstmt.setString(2, mem_id);
						pstmt.setString(3, mem_type);
						pstmt.setString(4,isbn);
						pstmt.setString(5,reserve_date);
						 int flag=pstmt.executeUpdate();
						 if(flag==1)
								response.sendRedirect("issue?access="+accession_no+"&status=Book+Reserved");
					}
			}
		con.close();		
		}catch (Exception e) {
			// TODO: handle exception
		}
	}

}
