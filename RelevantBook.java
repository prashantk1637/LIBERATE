package recommendation;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.liberate.BookDetailsBean;
import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.ResultSet;

/**
 * Servlet implementation class RelevantBook
 */
@WebServlet("/bookCatalog")
public class RelevantBook extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RelevantBook() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession s=request.getSession(false);
		String user=(String)s.getAttribute("user");
		String userType=(String)s.getAttribute("userType");
		PrintWriter out=response.getWriter();
		if(user==null)
			response.sendRedirect("/Liberate?error=Login+first");
		if(userType.equals("librarian"))
			response.sendRedirect("error.jsp");
		
		String sql="select interest from userinterest where email=?";
		HashSet<String> isbn_set=new HashSet<>();
		HashMap<String, String> isbn_tag=new HashMap<>();
		
		try{
				Class.forName("com.mysql.jdbc.Driver");  
				Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
				PreparedStatement pstmt=(PreparedStatement) con.prepareStatement(sql);
				pstmt.setString(1, user);
			ResultSet rs=(ResultSet) pstmt.executeQuery();
			String tags[]=null;
			if(rs.next())
			{
				
				tags=rs.getString(1).split(":");
				sql="select isbn, tag from book_tag";
				pstmt=(PreparedStatement) con.prepareStatement(sql);
				rs=(ResultSet) pstmt.executeQuery();
				while(rs.next())
				{
					isbn_tag.put(rs.getString(1), rs.getString(2));
				}
				for(String str: tags)
				{
					for(String key:isbn_tag.keySet())
					{
						String tag_value=isbn_tag.get(key);
						String book_tag[]=tag_value.split(":");
						for(String str1: book_tag)
						{
							if(str.equals(str1))
							{
								isbn_set.add(key);
								break;
							}
						}
					
						
					}
				}
				sql="select accession_no,path,title,author,edition,isbn from books where isbn=?";
				ArrayList<BookDetailsBean> list=new ArrayList<>();
				pstmt=(PreparedStatement) con.prepareStatement(sql);
				for(String isbn:isbn_set)
				{	BookDetailsBean obj=new BookDetailsBean();
					pstmt.setString(1,isbn);
					rs=(ResultSet)pstmt.executeQuery();
					
					if(rs.next())
					{
						
						obj.setAccession_no(rs.getInt(1));
						obj.setPath(rs.getString(2));
						obj.setTitle(rs.getString(3));
						obj.setAuthor(rs.getString(4));
						obj.setEdition(rs.getString(5));
						
					}
					list.add(obj);
					
				}
				request.setAttribute("LIST", list);
				RequestDispatcher rd=request.getRequestDispatcher("/relevantBookCatalog.jsp");
				rd.forward(request, response);
			}
			else
			{
				RequestDispatcher rd=request.getRequestDispatcher("/catalog");
				rd.forward(request, response);
			}
			
			
		}catch (Exception e) {}
	}
}