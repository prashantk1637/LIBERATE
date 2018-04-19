/**
 * This servlet is used by Librarian to 
 * return issued books
 * 
 */




package com.liberate;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Date;
import java.sql.DriverManager;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

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
 * Servlet implementation class BookReturnedByLibrarian
 */
@WebServlet("/returned")
public class BookReturnedByLibrarian extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookReturnedByLibrarian() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int accession_no=Integer.parseInt(request.getParameter("accession_no"));
		PrintWriter out=response.getWriter();
		HttpSession s=request.getSession(false);
		String user=(String)s.getAttribute("user");
		DateFormat df=new SimpleDateFormat("dd/MM/yyyy");
		Date d=new Date();
		String issue_approval="";
		String return_status="returned";
		String return_date=df.format(d);
		String due_date;
		int fine=0,x=0;
		if(user==null)
			response.sendRedirect("/Liberate?error=Login+first");
			PreparedStatement selectpstmt,insertpstmt,pstmt;
			String check="select issue_approval,accession_no,mem_id,mem_type,librarian_id,issue_date,return_date from issue where accession_no=?";
			String fetch="select * from issue where accession_no=?";
			String insert="insert into returned values(?,?,?,?,?,?,?,?,?)";
			String deletesql="delete from issue where accession_no=?";
			String reserve_confirm="select accession_no,mem_id, mem_type,reserve_date from reserve where accession_no=?";
			String mem_id,isbn=null,req_for_issue_date=null;
			try{
					Class.forName("com.mysql.jdbc.Driver");  
					Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
					pstmt=(PreparedStatement) con.prepareStatement(check);
					pstmt.setInt(1, accession_no);
					ResultSet rs=(ResultSet)pstmt.executeQuery();
					if(rs.next())
					{	
						issue_approval=rs.getString(1);
					}
					
					if(issue_approval.equals("pending"))
						response.sendRedirect("librarian.jsp?returned=Book+NOT issued yet");
					else if(issue_approval.equals("issued")){
						selectpstmt=(PreparedStatement) con.prepareStatement(fetch);
							selectpstmt.setInt(1, accession_no);
							rs=(ResultSet)selectpstmt.executeQuery();
							
							if(rs.next())
							{
				
								insertpstmt=(PreparedStatement) con.prepareStatement(insert);
								insertpstmt.setInt(1, rs.getInt(1));
									mem_id=rs.getString(2);
								insertpstmt.setString(2, mem_id);
								insertpstmt.setString(3,rs.getString(3));
								isbn=rs.getString(4);
								req_for_issue_date=rs.getString(6);
								insertpstmt.setString(4, rs.getString(5));
								insertpstmt.setString(5, rs.getString(7));
								insertpstmt.setString(6, rs.getString(8));
								insertpstmt.setString(7, return_date);
								due_date=rs.getString(8);
								Date d1 = new SimpleDateFormat("dd/MM/yyyy").parse(due_date);
								Date d2 = new SimpleDateFormat("dd/MM/yyyy").parse(return_date);
								long diff = d2.getTime() - d1.getTime();
								long days=(diff / (1000 * 60 * 60 * 24));
								if(days<0)
									fine=0;
								else fine=(int) (2*days);
								insertpstmt.setInt(8,fine);
								insertpstmt.setString(9,return_status);
								int flag=insertpstmt.executeUpdate();
								if(flag==1)
								{	
									pstmt=(PreparedStatement) con.prepareStatement(deletesql);
									pstmt.setInt(1, accession_no);
									pstmt.executeUpdate();
									ReturnStatusBean obj=new ReturnStatusBean();
									obj.setAccession_no(rs.getInt(1));
									obj.setMem_id(rs.getString(2));
									obj.setMem_type(rs.getString(3));
									obj.setIssue_date(rs.getString(7));
									obj.setDue_date(due_date);
									obj.setReturn_date(return_date);
									obj.setFine_paid(fine);
									obj.setReturned_approval(return_status);
									request.setAttribute("RETURN",obj);
									
									//from reserve to issue request functionality
									ArrayList<ReservedBookBean> reserve_list=new ArrayList<>();
									String min_date=null;
									String member_id=null;
									String member_type=null;
									pstmt=(PreparedStatement) con.prepareStatement(reserve_confirm);
									pstmt.setInt(1, accession_no);
									rs=(ResultSet)pstmt.executeQuery();
									while(rs.next())
									{
										ReservedBookBean o=new ReservedBookBean();
										o.setAccession_no(rs.getInt(1));
										o.setMem_id(rs.getString(2));
										o.setMem_type(rs.getString(3));
										o.setReserved_date(rs.getString(4));
										reserve_list.add(o);
										
									}
									if(reserve_list.size()==1)
									{		ReserveToIssue ob=new ReserveToIssue();
											ReservedBookBean o1=reserve_list.get(0);
											member_id=o1.getMem_id();
											member_type=o1.getMem_type();
											x=ob.insertToIssue(accession_no,member_id,member_type,isbn,req_for_issue_date,"pending");
									}
									else if(reserve_list.size()>1)
									{	SimpleDateFormat df1 = new SimpleDateFormat("dd/MM/yyyy");
									 	SimpleDateFormat df2 = new SimpleDateFormat("yyyy-MM-dd");
									 	ReservedBookBean o1=reserve_list.get(0);
									 	Date r_date1 = df1.parse(o1.getReserved_date());
										min_date=df2.format(r_date1);
										member_id=o1.getMem_id();
										member_type=o1.getMem_type();
										for(int i=1;i<reserve_list.size();i++)
										{	ReservedBookBean o2=reserve_list.get(i);
											Date r_date2 = df1.parse(o2.getReserved_date());
											String reserve_date2=df2.format(r_date2);
											if(df2.parse(min_date).compareTo(df2.parse(reserve_date2))>=0)
											{
												min_date=reserve_date2;
												member_id=o2.getMem_id();
												member_type=o2.getMem_type();
												
											}
											
											 
											 
										}
										ReserveToIssue ob=new ReserveToIssue();
										x=ob.insertToIssue(accession_no,member_id,member_type,isbn,req_for_issue_date,"pending");
										
								
									}
									if(x==1)
									{	String confirm="Your reservation has been confirmed!! Please go to library to issue the book";
										String sql="update reserve set status=? where accession_no=? and mem_id=?";
										pstmt=(PreparedStatement) con.prepareStatement(sql);
										pstmt.setString(1, confirm);
										pstmt.setInt(2, accession_no);
										pstmt.setString(3, member_id);
										pstmt.executeUpdate();
										
									}
									
									
									
									
									
									RequestDispatcher rd=request.getRequestDispatcher("/librarian.jsp");
									rd.forward(request, response);								
									
								}
								
							}
							
							
							
						
						}
						
					
			con.close();		
			}catch (Exception e) {
				// TODO: handle exception
			}
	
	}

}
