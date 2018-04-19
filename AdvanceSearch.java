package com.liberate;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
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
 * Servlet implementation class AdvanceSearch
 */
@WebServlet("/AdvanceSearch")
public class AdvanceSearch extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdvanceSearch() {
        super();
        // TODO Auto-generated constructor stub
    }
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out=response.getWriter();
		
		String title=request.getParameter("title");
		String author=request.getParameter("author");
		String publisher=request.getParameter("publisher");
		String publication_year=request.getParameter("publication_year");
		String keyword=request.getParameter("keyword");
		if(title==""&&author==""&&publisher==""&&publication_year==""&&keyword=="")
		{	
			response.sendRedirect("/Liberate/advanceSearch.jsp?search_error=At least one field is required");
		}
		else
		{
			String sql;
			int flag=0;
			PreparedStatement pstmt=null;
			Connection con;
			HashSet<String> isbn_set_by_title=new HashSet<>();
			HashSet<String> isbn_set_by_author=new HashSet<>();
			HashSet<String> isbn_set_by_publisher=new HashSet<>();
			HashSet<String> isbn_set_by_publication_year=new HashSet<>();
			HashSet<String> isbn_set_by_keyword=new HashSet<>();
			
			HashSet<String> relevant_isbn_set=new HashSet<>();
		
			try {
				Class.forName("com.mysql.jdbc.Driver");
				con=DriverManager.getConnection("jdbc:mysql://localhost:3306/liberate","root","");
				if(title!="")
				{	
					sql="select title,isbn_no from stdsearch";
					pstmt=(PreparedStatement) con.prepareStatement(sql);
					ResultSet rs=(ResultSet)pstmt.executeQuery();
					while(rs.next())
					{
						if(rs.getString(1).contains(title.toLowerCase()))
						{
							isbn_set_by_title.add(rs.getString(2));
							// calculating item similarity
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
					}
					request.setAttribute("ISBN_LIST",isbn_set_by_title);
				}
				if(author!="")
				{
					String search_query_key[]=author.split("\\s+");
					sql="select author,isbn_no from stdsearch";
					pstmt=(PreparedStatement) con.prepareStatement(sql);
					ResultSet rs=(ResultSet)pstmt.executeQuery();
					while(rs.next())
					{
						
							for(String str1: search_query_key)
							{     
								if(rs.getString(1).contains(str1.toLowerCase())&&str1.length()>1)
								{
				
										isbn_set_by_author.add(rs.getString(2));
										// calculating item similarity
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
							}
						
					}
					
					request.setAttribute("ISBN_LIST",isbn_set_by_author);
				}
				if(publisher!="")
				{
					String search_query_key[]=publisher.split("\\s+");
					sql="select publisher,isbn from books";
					pstmt=(PreparedStatement) con.prepareStatement(sql);
					ResultSet rs=(ResultSet)pstmt.executeQuery();
					while(rs.next())
					{
						for(String str1: search_query_key)
						{ 
							if(rs.getString(1).toLowerCase().contains(str1.toLowerCase())&&str1.length()>1)
							{
								isbn_set_by_publisher.add(rs.getString(2));
								// calculating item similarity
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
						}
					}
					request.setAttribute("ISBN_LIST",isbn_set_by_publisher);
				}
				if(publication_year!="")
				{
				
					sql="select publisher,isbn from books where publication_year=?";
					pstmt=(PreparedStatement) con.prepareStatement(sql);
					pstmt.setInt(1, Integer.parseInt(publication_year));
					ResultSet rs=(ResultSet)pstmt.executeQuery();
					while(rs.next())
					{
						
								isbn_set_by_publication_year.add(rs.getString(2));
								// calculating item similarity
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
					request.setAttribute("ISBN_LIST",isbn_set_by_publication_year);
				}
				if(keyword!="")
				{
					String search_query_key[]=keyword.split("\\s+");
					sql="select distinct keyword,isbn_no from stdsearch";
					pstmt=(PreparedStatement) con.prepareStatement(sql);
					ResultSet rs=(ResultSet)pstmt.executeQuery();
					while(rs.next())
					{
						for(String str1: search_query_key)
						{     
							if(rs.getString(1).contains(str1.toLowerCase()))
							{
			
									isbn_set_by_keyword.add(rs.getString(2));
									// calculating item similarity
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
						}
					}
					request.setAttribute("ISBN_LIST",isbn_set_by_keyword);	
				}
				
				//intersection of all sets
				if(isbn_set_by_title.size()>0 && flag==0)
				{
					if(author!="")
						isbn_set_by_title.retainAll(isbn_set_by_author);
					if(publisher!="")
						isbn_set_by_title.retainAll(isbn_set_by_publisher);
					if(publication_year!="")
						isbn_set_by_title.retainAll(isbn_set_by_publication_year);
					if(keyword!="")
						isbn_set_by_title.retainAll(isbn_set_by_keyword);
					flag=1;	
					relevant_isbn_set.removeAll(isbn_set_by_title);
					request.setAttribute("ISBN_LIST",isbn_set_by_title);
				}
				if(isbn_set_by_author.size()>0 && flag==0)
				{	
					if(title!="")
						isbn_set_by_author.retainAll(isbn_set_by_title);
					if(publisher!="")
						isbn_set_by_author.retainAll(isbn_set_by_publisher);
					if(publication_year!="")
						isbn_set_by_author.retainAll(isbn_set_by_publication_year);
					if(keyword!="")
						isbn_set_by_author.retainAll(isbn_set_by_keyword);
					flag=1;
					relevant_isbn_set.removeAll(isbn_set_by_author);
					request.setAttribute("ISBN_LIST",isbn_set_by_author);
				}
				if(isbn_set_by_publisher.size()>0 && flag==0)
				{	
					if(title!="")
						isbn_set_by_publisher.retainAll(isbn_set_by_title);
					if(author!="")
						isbn_set_by_publisher.retainAll(isbn_set_by_author);
					if(publication_year!="")
						isbn_set_by_publisher.retainAll(isbn_set_by_publication_year);
					if(keyword!="")
						isbn_set_by_publisher.retainAll(isbn_set_by_keyword);
					flag=1;
					relevant_isbn_set.removeAll(isbn_set_by_publisher);
					request.setAttribute("ISBN_LIST",isbn_set_by_publisher);
				}
				if(isbn_set_by_publication_year.size()>0 && flag==0)
				{	
					if(title!="")
						isbn_set_by_publication_year.retainAll(isbn_set_by_title);
					if(author!="")
						isbn_set_by_publication_year.retainAll(isbn_set_by_author);
					if(publisher!="")
						isbn_set_by_publication_year.retainAll(isbn_set_by_publisher);
					if(keyword!="")
						isbn_set_by_publication_year.retainAll(isbn_set_by_keyword);
					flag=1;
					relevant_isbn_set.removeAll(isbn_set_by_publication_year);
					request.setAttribute("ISBN_LIST",isbn_set_by_publication_year);
				}
				if(isbn_set_by_keyword.size()>0 && flag==0)
				{	
					if(title!="")
						isbn_set_by_keyword.retainAll(isbn_set_by_title);
					if(author!="")
						isbn_set_by_keyword.retainAll(isbn_set_by_author);
					if(publisher!="")
						isbn_set_by_keyword.retainAll(isbn_set_by_publisher);
					if(publication_year!="")
						isbn_set_by_keyword.retainAll(isbn_set_by_publication_year);
					flag=1;
					relevant_isbn_set.removeAll(isbn_set_by_keyword);
					request.setAttribute("ISBN_LIST",isbn_set_by_keyword);
				}
				
				}catch (Exception e) {
					// TODO: handle exception
				}
			
			request.setAttribute("RELEVANT_ISBN_LIST",relevant_isbn_set);
			RequestDispatcher rd=request.getRequestDispatcher("/stdresult");
			rd.forward(request, response);
			
		}
	}

}
