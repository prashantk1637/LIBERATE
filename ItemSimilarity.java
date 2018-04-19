package recommendation;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.*;
import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.ResultSet;

public class ItemSimilarity extends Thread  {

	
	public void run(){
		
	PreparedStatement pstmt;
	Connection con;
	String delete_sql="delete from itemsimilarity";
	String sql="select isbn , tag from book_tag";
	ArrayList<ItemSimilarityBean> item_list=new ArrayList<>();
	
	try {
		Class.forName("com.mysql.jdbc.Driver");
		con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");
		System.out.println("connected");
		pstmt=(PreparedStatement) con.prepareStatement(delete_sql);
		pstmt.executeUpdate();
		pstmt=(PreparedStatement) con.prepareStatement(sql);
		ResultSet rs=(ResultSet)pstmt.executeQuery();
		while(rs.next())
		{
			ItemSimilarityBean obj=new ItemSimilarityBean();
			obj.setIsbn(rs.getString(1));
			obj.setTag(rs.getString(2));
			item_list.add(obj);
		}
		
		for(ItemSimilarityBean obj1: item_list)
		{	
			
			for(ItemSimilarityBean obj2: item_list)
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
				sql="insert into itemsimilarity values(?,?,?)";
				pstmt=(PreparedStatement) con.prepareStatement(sql);
				pstmt.setString(1, obj1.getIsbn());
				pstmt.setString(2, obj2.getIsbn());
				pstmt.setFloat(3, similarity);
				pstmt.executeUpdate();
				
			}
			
		}
	 
	}catch (Exception e) {}
	}
	
		
	
			
	
}
