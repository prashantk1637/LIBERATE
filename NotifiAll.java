package com.liberate;

import java.io.IOException;
import java.sql.DriverManager;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.ResultSet;

/**
 * Servlet implementation class NotifiAll
 */
@WebServlet("/notifyAll")
public class NotifiAll extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NotifiAll() {
        super();
        // TODO Auto-generated constructor stub
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		int flag=0;
		PreparedStatement pstmt=null;
		ArrayList<IssuedBookedDetailsBean> list=new ArrayList<>();
		String sql="select accession_no,mem_id,issue_date,return_date from issue where issue_approval=?";
		try{
				Class.forName("com.mysql.jdbc.Driver");  
				Connection con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
				pstmt=(PreparedStatement) con.prepareStatement(sql);
				pstmt.setString(1, "issued");
				ResultSet rs=(ResultSet) pstmt.executeQuery();
				
				while(rs.next())
				{
					String sql1="select path,title,author,subject,edition,isbn,publisher,publication_year from books where accession_no=?";
					pstmt=(PreparedStatement) con.prepareStatement(sql1);
					pstmt.setInt(1,rs.getInt(1));
					ResultSet rs1=(ResultSet) pstmt.executeQuery();
					if(rs1.next())
					{
						IssuedBookedDetailsBean obj=new IssuedBookedDetailsBean();
						obj.setAccession_no(rs.getInt(1));
						obj.setMem_id(rs.getString(2));
						obj.setIssue_date(rs.getString(3));
						obj.setReturn_date(rs.getString(4));
						obj.setPath(rs1.getString(1));
						obj.setTitle(rs1.getString(2));
						obj.setAuthor(rs1.getString(3));
						obj.setSubject(rs1.getString(4));
						obj.setEdition(rs1.getString(5));
						obj.setIsbn(rs1.getString(6));
						obj.setPublisher(rs1.getString(7));
						obj.setPublication_year(rs1.getInt(8));
						list.add(obj);
					}
				}
				
				SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
			 	SimpleDateFormat df1 = new SimpleDateFormat("yyyy-MM-dd");
			 	Date d=new Date();
			 	String today=df.format(d);
			 	
				for(IssuedBookedDetailsBean o: list){
				
					int accession_no=o.getAccession_no();
					String path=o.getPath();
					String title=o.getTitle();
					String author=o.getAuthor();
					String subject=o.getSubject();
					String edition=o.getEdition();
					String isbn=o.getIsbn();
					String publisher=o.getPublisher();
					int publication_year=o.getPublication_year();
					String mem_id=o.getMem_id();
					String notification=title+" by "+author;
					//String notification=URLEncoder.encode( notifications, "UTF-8" ); 
					String issue_date_db=o.getIssue_date();
					String due_date_db=o.getReturn_date();
					Date date = df.parse(due_date_db);
				 	String due_date=df1.format(date);
					Date td=df.parse(today);
					String tday=df1.format(td);
					if(df1.parse(tday).compareTo(df1.parse(due_date))>0){
						
						sql="insert into notification(mem_id,notification,due_date,notification_date,catchup) values(?,?,?,?,?)";
						pstmt=(PreparedStatement) con.prepareStatement(sql);
						pstmt.setString(1, mem_id);
						pstmt.setString(2, notification);
						pstmt.setString(3,due_date_db);
						pstmt.setString(4,today);
						pstmt.setString(5, "NO");
						flag=pstmt.executeUpdate();
					}
				}

			con.close();
			}catch (Exception e) {}
		request.setAttribute("notifyall","All are notified" );
		RequestDispatcher rd=request.getRequestDispatcher("/bookDueFromMember.jsp");
		rd.forward(request, response);	
	
	}


}
