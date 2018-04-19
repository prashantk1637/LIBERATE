package com.liberate;

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

import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.ResultSet;

import recommendation.InsertTag;

/**
 * Servlet implementation class StdSearchServlet
 */
@WebServlet("/stdSearch")
public class StdSearchServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public StdSearchServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String search_query=request.getParameter("search_query").toLowerCase().trim();
		String search_by=request.getParameter("search_by");
		
		String sql;
		PrintWriter out=response.getWriter();
		PreparedStatement pstmt=null;
		Connection con;
		HashSet<String> isbn_set=new HashSet<>();
		HashSet<String> relevant_isbn_set=new HashSet<>();
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");
			if(search_by.equals("title"))
			{	int flag=0;
				sql="select title,isbn_no from stdsearch";
				pstmt=(PreparedStatement) con.prepareStatement(sql);
				ResultSet rs=(ResultSet)pstmt.executeQuery();
					
				while(rs.next())
				{
					if(rs.getString(1).contains(search_query))
					{
						isbn_set.add(rs.getString(2));
						//select from item similarity table for getting similar items
						String sql1="select isbn2, similarity from itemsimilarity where isbn1=? and similarity>?";
						PreparedStatement pstmt1=(PreparedStatement)con.prepareStatement(sql1);
						pstmt1.setString(1, rs.getString(2));
						pstmt1.setFloat(2, 0);
						ResultSet rs1=(ResultSet) pstmt1.executeQuery();
						while(rs1.next())
						{
							relevant_isbn_set.add(rs1.getString(1));
						}
						if(flag==0)
						{
							new InsertTag(search_query,search_by);// call constructor of InsertTag class to insert Tag
							flag=1;
						}
					}
				}

				
			}
			else if(search_by.equals("author"))
			{	int flag=0;
				String search_query_key[]=search_query.split("\\s+");
				sql="select author,isbn_no from stdsearch";
				pstmt=(PreparedStatement) con.prepareStatement(sql);
				ResultSet rs=(ResultSet)pstmt.executeQuery();
				while(rs.next())
				{
					
						for(String str1: search_query_key)
						{     
							if(rs.getString(1).contains(str1.toLowerCase())&&str1.length()>1)
							{
			
									isbn_set.add(rs.getString(2));
									//select from item similarity table for getting similar items
									String sql1="select isbn2, similarity from itemsimilarity where isbn1=? and similarity>?";
									PreparedStatement pstmt1=(PreparedStatement)con.prepareStatement(sql1);
									pstmt1.setString(1, rs.getString(2));
									pstmt1.setFloat(2, 0.5f);
									ResultSet rs1=(ResultSet) pstmt1.executeQuery();
									while(rs1.next())
									{
										relevant_isbn_set.add(rs1.getString(1));
									}
									if(flag==0)
									{
										new InsertTag(search_query,search_by);// call constructor of InsertTag class to insert Tag
										flag=1;
									}
							}
						}
					
				}

			}
			
			else if(search_by.equals("keyword"))
			{	int flag=0;
				sql="select distinct keyword,isbn_no from stdsearch";
				pstmt=(PreparedStatement) con.prepareStatement(sql);
				ResultSet rs=(ResultSet)pstmt.executeQuery();
				
				while(rs.next())
				{	String db_tags=rs.getString(1);
					
					if(db_tags.contains(search_query))
					{
						isbn_set.add(rs.getString(2));
						
							if(flag==0)
							{
								new InsertTag(search_query,search_by);// call constructor of InsertTag class to insert Tag for tag cloud
								flag=1;
							}
							//select from item similarity table for getting similar items
									String sql1="select isbn2, similarity from itemsimilarity where isbn1=? and similarity>?";
									PreparedStatement pstmt1=(PreparedStatement)con.prepareStatement(sql1);
									pstmt1.setString(1, rs.getString(2));
									pstmt1.setFloat(2, 0);
									ResultSet rs1=(ResultSet) pstmt1.executeQuery();
									while(rs1.next())
									{
										relevant_isbn_set.add(rs1.getString(1));
									}
					}
					else{
						String search_query_key[]=search_query.split("\\s+");
						
						for(String str: search_query_key)
						{	
								if(db_tags.contains(str))
								{	
									sql="select distinct isbn_no from stdsearch where keyword=?";
									pstmt=(PreparedStatement) con.prepareStatement(sql);
									pstmt.setString(1, rs.getString(1));
									ResultSet rs1=(ResultSet)pstmt.executeQuery();
									
									while(rs1.next())
									{
										relevant_isbn_set.add(rs1.getString(1));
										if(flag==0)
										{
											new InsertTag(search_query,search_by);// call constructor of InsertTag class to insert Tag
											flag=1;
										}
										
									}
									
								}
						}
					} //end else
					
				}
				
				
			}
			relevant_isbn_set.removeAll(isbn_set);
			request.setAttribute("ISBN_LIST",isbn_set);
			request.setAttribute("RELEVANT_ISBN_LIST",relevant_isbn_set);
			RequestDispatcher rd=request.getRequestDispatcher("/stdresult");
			rd.forward(request, response);
			
				
			con.close();		
	}catch (Exception e) {
		
	}

}
}