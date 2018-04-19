package recommendation;

import java.sql.Connection;
import java.sql.DriverManager;

import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.ResultSet;

public class InsertTag {
	String tag;
	String tag_type;
	int count;
	public InsertTag(String tag, String tag_type)
	{
		this.tag=tag;
		this.tag_type=tag_type;
		fetch();
	}
	void fetch() {
		PreparedStatement pstmt;
		Connection con;
		String tag_insert="insert into tagcloud (tag,tag_type,count) values(?,?,?)";
		String tag_fetch="select count from tagcloud where tag=?";
		String update_count="UPDATE tagcloud SET count=? where tag=?";
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");
			
			pstmt=(PreparedStatement) con.prepareStatement(tag_fetch);
			pstmt.setString(1, tag);
			ResultSet rs=(ResultSet)pstmt.executeQuery();
			if(rs.next())
			{	
				count=rs.getInt(1);
				count=count+1;
				pstmt=(PreparedStatement) con.prepareStatement(update_count);
				pstmt.setInt(1,count);
				pstmt.setString(2,tag);
				pstmt.executeUpdate();
				
			}
			else {
				
				pstmt=(PreparedStatement) con.prepareStatement(tag_insert);
				pstmt.setString(1, tag);
				pstmt.setString(2,tag_type);
				pstmt.setInt(3, 1);
				pstmt.executeUpdate();
			}
		}catch (Exception e) {
			// TODO: handle exception
		}
		
	}
}
