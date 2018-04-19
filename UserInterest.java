package recommendation;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.mysql.jdbc.PreparedStatement;

/**
 * Servlet implementation class UserInterest
 */
@WebServlet("/userinterest")
public class UserInterest extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UserInterest() {
        super();
        // TODO Auto-generated constructor stub
    }
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession s=request.getSession(false);
		PrintWriter out=response.getWriter();
		String user=(String)s.getAttribute("user");
		if(user==null)
			response.sendRedirect("/Liberate?error=Login+first");
		String email=request.getParameter("email");
		String ch1=request.getParameter("ch1");
		String ch2=request.getParameter("ch2");
		String ch3=request.getParameter("ch3");
		String ch4=request.getParameter("ch4");
		String ch5=request.getParameter("ch5");
		String ch6=request.getParameter("ch6");
		String ch7=request.getParameter("ch7");
		String ch8=request.getParameter("ch8");
		String ch9=request.getParameter("ch9");
		String ch10=request.getParameter("ch10");
		String other=request.getParameter("other");
		String interest="";
		if(ch1!=null)
			interest=interest+ch1+':';
		if(ch2!=null)
			interest=interest+ch2+':';
		if(ch3!=null)
			interest=interest+ch3+':';
		if(ch4!=null)
			interest=interest+ch4+':';
		if(ch5!=null)
			interest=interest+ch5+':';
		if(ch6!=null)
			interest=interest+ch6+':';
		if(ch7!=null)
			interest=interest+ch7+':';
		if(ch8!=null)
			interest=interest+ch8+':';
		
		if(ch9!=null)
			interest=interest+ch9+':';
		if(ch10!=null)
			interest=interest+ch10+':';
		if(other!=null)
			interest=interest+other;
		String sql="insert into userinterest values(?,?)";
		PreparedStatement pstmt;
		Connection con;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");
			pstmt=(PreparedStatement) con.prepareStatement(sql);
			pstmt.setString(1,email);
			pstmt.setString(2,interest);
			int flag=pstmt.executeUpdate();
		
			if(flag==1)
				response.sendRedirect("/Liberate/member.jsp?interest=Thanks for sharing your interest");
			
		
		}catch (Exception e) {}


	}
}
