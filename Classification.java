package recommendation;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.liberate.BookDetailsBean;
import com.mysql.jdbc.PreparedStatement;

/**
 * Servlet implementation class Classifiaction
 */
@WebServlet("/classification")
public class Classification extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Classification() {
        super();
        // TODO Auto-generated constructor stub
    }
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out=response.getWriter();
		PreparedStatement pstmt;
		String sql="select isbn,tag from book_tag";
		ArrayList<ClassificationBean> list=new ArrayList<>();
		try{
				Class.forName("com.mysql.jdbc.Driver");  
				Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
				pstmt=(PreparedStatement) con.prepareStatement(sql);
				ResultSet rs=(ResultSet)pstmt.executeQuery();
				while(rs.next())
				{
					String isbn=rs.getString(1);
					String[] strArr=rs.getString(2).split(":");
					String tag=strArr[0];
					ClassificationBean obj=new ClassificationBean();
							obj.setIsbn(isbn);
							obj.setTag(tag);
							list.add(obj);
					
				}
				ArrayList<BookDetailsBean> cse_list=new ArrayList<>();
				ArrayList<BookDetailsBean> ece_list=new ArrayList<>();
				ArrayList<BookDetailsBean> me_list=new ArrayList<>();
				ArrayList<BookDetailsBean> math_list=new ArrayList<>();
				sql="select accession_no,path,title,author from books where isbn=?";
				pstmt=(PreparedStatement) con.prepareStatement(sql);
				for(ClassificationBean o: list)
				{
					if(o.getTag().equals("cse") || o.getTag().equals("it"))
					{
						pstmt.setString(1, o.getIsbn());
						rs=(ResultSet)pstmt.executeQuery();
						if(rs.next())
						{
							BookDetailsBean obj=new BookDetailsBean();
							obj.setAccession_no(rs.getInt(1));
							obj.setPath(rs.getString(2));
							obj.setTitle(rs.getString(3));
							obj.setAuthor(rs.getString(4));
							cse_list.add(obj);
						}
							
					}
					if(o.getTag().equals("ece"))
					{
						pstmt.setString(1, o.getIsbn());
						rs=(ResultSet)pstmt.executeQuery();
						if(rs.next())
						{
							BookDetailsBean obj=new BookDetailsBean();
							obj.setAccession_no(rs.getInt(1));
							obj.setPath(rs.getString(2));
							obj.setTitle(rs.getString(3));
							obj.setAuthor(rs.getString(4));
							ece_list.add(obj);
						}
							
					}
					if(o.getTag().equals("me"))
					{
						pstmt.setString(1, o.getIsbn());
						rs=(ResultSet)pstmt.executeQuery();
						if(rs.next())
						{
							BookDetailsBean obj=new BookDetailsBean();
							obj.setAccession_no(rs.getInt(1));
							obj.setPath(rs.getString(2));
							obj.setTitle(rs.getString(3));
							obj.setAuthor(rs.getString(4));
							me_list.add(obj);
						}
							
					}
					if(o.getTag().equals("math"))
					{
						pstmt.setString(1, o.getIsbn());
						rs=(ResultSet)pstmt.executeQuery();
						if(rs.next())
						{
							BookDetailsBean obj=new BookDetailsBean();
							obj.setAccession_no(rs.getInt(1));
							obj.setPath(rs.getString(2));
							obj.setTitle(rs.getString(3));
							obj.setAuthor(rs.getString(4));
							math_list.add(obj);
						}
							
					}
					
				}
		}catch (Exception e) {}
	}

}
