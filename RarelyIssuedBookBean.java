package recommendation;

public class RarelyIssuedBookBean {
	private String path;
	private String title;
	private String author;
	private String isbn;
	private String edition;
	private int publication_year;
	private String publisher;
	private int total_copy;
	private int no_issued_copy;
	private double issue_by_total_fraction;
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getAuthor() {
		return author;
	}
	public void setAuthor(String author) {
		this.author = author;
	}
	public String getIsbn() {
		return isbn;
	}
	public void setIsbn(String isbn) {
		this.isbn = isbn;
	}
	public String getEdition() {
		return edition;
	}
	public void setEdition(String edition) {
		this.edition = edition;
	}
	public int getPublication_year() {
		return publication_year;
	}
	public void setPublication_year(int publication_year) {
		this.publication_year = publication_year;
	}
	public String getPublisher() {
		return publisher;
	}
	public void setPublisher(String publisher) {
		this.publisher = publisher;
	}
	public int getTotal_copy() {
		return total_copy;
	}
	public void setTotal_copy(int total_copy) {
		this.total_copy = total_copy;
	}
	public int getNo_issued_copy() {
		return no_issued_copy;
	}
	public void setNo_issued_copy(int no_issued_copy) {
		this.no_issued_copy = no_issued_copy;
	}
	public double getIssue_by_total_fraction() {
		return issue_by_total_fraction;
	}
	public void setIssue_by_total_fraction(double issue_by_total_fraction) {
		this.issue_by_total_fraction = issue_by_total_fraction;
	}
	
	

}
