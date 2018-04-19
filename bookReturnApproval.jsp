<%@page import="com.liberate.ReturnStatusBean"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="com.mysql.jdbc.Connection"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.mysql.jdbc.PreparedStatement"%>
<%
HttpSession s=request.getSession(false);
String user=(String)s.getAttribute("user");
String userType=(String)s.getAttribute("userType");
DateFormat df=new SimpleDateFormat("dd/MM/yyyy");
Date d=new Date();
	//return approval
		int accession_no=Integer.parseInt(request.getParameter("accession_no"));
	
		String issue_approval="pending";
		String return_status="pending";
		String return_date=df.format(d);
		String due_date=null;
		int fine=0,x=0;
		if(user==null)
			response.sendRedirect("/Liberate?error=Login+first");
			PreparedStatement selectpstmt,insertpstmt;
			String check="select issue_approval,accession_no,mem_id,mem_type,librarian_id,issue_date,return_date from issue where accession_no=?";
			String fetch="select * from issue where accession_no=?";
			String insert="insert into returned values(?,?,?,?,?,?,?,?,?)";
			String deletesql="delete from issue where accession_no=?";
			String reserve_confirm="select accession_no,mem_id, mem_type,reserve_date from reserve where accession_no=?";
			String isbn=null,req_for_issue_date=null;
			try{
					Class.forName("com.mysql.jdbc.Driver");  
					Connection con=(Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
					PreparedStatement pstmt=(PreparedStatement) con.prepareStatement(check);
					pstmt.setInt(1, accession_no);
					ResultSet rs=(ResultSet)pstmt.executeQuery();
					if(rs.next())
					{	
						issue_approval=rs.getString(1);
					}
					
					if(issue_approval.equals("pending"))
						response.sendRedirect("librarian.jsp?returned=Book+NOT issued yet");
					else if(issue_approval.equals("issued"))
					{
						selectpstmt=(PreparedStatement) con.prepareStatement(fetch);
							selectpstmt.setInt(1, accession_no);
							rs=(ResultSet)selectpstmt.executeQuery();
							
							if(rs.next())
							{
								ReturnStatusBean ob=new ReturnStatusBean();
								ob.setAccession_no(rs.getInt(1));
								ob.setMem_id(rs.getString(2));
								ob.setMem_type(rs.getString(3));
								ob.setIssue_date(rs.getString(7));
								due_date=rs.getString(8);
								ob.setDue_date(due_date);
								ob.setReturn_date(return_date);
								Date d1 = new SimpleDateFormat("dd/MM/yyyy").parse(due_date);
								Date d2 = new SimpleDateFormat("dd/MM/yyyy").parse(return_date);
								long diff = d2.getTime() - d1.getTime();
								long days=(diff / (1000 * 60 * 60 * 24));
								if(days<0)
									fine=0;
								else fine=(int) (2*days);
								ob.setFine_paid(fine);
								ob.setReturned_approval(return_status);
								request.setAttribute("RETURN",ob);
								RequestDispatcher rd=request.getRequestDispatcher("/librarian.jsp");
								rd.forward(request, response);	
							}
					}
						
					
			con.close();		
			}catch (Exception e) {}
				




%>