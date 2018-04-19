package recommendation;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.ResultSet;

public class UserSimilarity extends Thread {

	public void run(){
		PreparedStatement pstmt;
		Connection con;
		String delete_sql="delete from usersimilarity";
		String sql="select email, interest from userinterest";
		ArrayList<UserSimilarityBean> user_list=new ArrayList<>();
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");
			pstmt=(PreparedStatement) con.prepareStatement(delete_sql);
			int flag=pstmt.executeUpdate();
			pstmt=(PreparedStatement) con.prepareStatement(sql);
			ResultSet rs=(ResultSet)pstmt.executeQuery();
			while(rs.next())
			{
				UserSimilarityBean obj=new UserSimilarityBean();
				obj.setMem_id(rs.getString(1));
				obj.setTag(rs.getString(2));
				user_list.add(obj);
			}
			
			for(UserSimilarityBean obj1: user_list)
			{	
				
				for(UserSimilarityBean obj2: user_list)
				{	
					List<String> list1=Arrays.asList(obj1.getTag().split(":"));
					List<String> list2=Arrays.asList(obj2.getTag().split(":"));
					ArrayList<String> intersect=new ArrayList<>();
					ArrayList<String> union=new ArrayList<>();
					intersect.addAll(list1); // initialize
					union.addAll(list1); //initialize
					
					
					intersect.retainAll(list2); //taking intersection
					
					union.removeAll(list2); // taking
					union.addAll(list2); ///  union
					
					float similarity=(float)intersect.size()/union.size(); // Jaccard similarity 
					sql="insert into usersimilarity values(?,?,?)";
					pstmt=(PreparedStatement) con.prepareStatement(sql);
					pstmt.setString(1, obj1.getMem_id());
					pstmt.setString(2, obj2.getMem_id());
					pstmt.setFloat(3, similarity);
					pstmt.executeUpdate();
					
				}
				
			}
		 
		}catch (Exception e) {}
		}
		

}
