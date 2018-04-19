package recommendation;

import java.sql.Connection;
import java.sql.DriverManager;

import com.mysql.jdbc.PreparedStatement;

public class PopularBooks 
{
	
		public void insertPopularBook(int accession_no, String isbn,String mem_id)
		{
			String sql="insert into popular_book values(?,?,?)";
			
			try{
					Class.forName("com.mysql.jdbc.Driver");  
					Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");  
					PreparedStatement pstmt=(PreparedStatement) con.prepareStatement(sql);
					pstmt.setInt(1,accession_no);
					pstmt.setString(2, isbn);
					pstmt.setString(3, mem_id);
					pstmt.executeUpdate();
			}catch (Exception e) {}
		}
}


