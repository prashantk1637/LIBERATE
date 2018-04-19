package recommendation;

public class ItemSimilarityBean {
	private String isbn;
	private String tag;
	private float similarity;
	public String getIsbn() {
		return isbn;
	}
	public void setIsbn(String isbn) {
		this.isbn = isbn;
	}
	public String getTag() {
		return tag;
	}
	public void setTag(String tag) {
		this.tag = tag;
	}
	public float getSimilarity() {
		return similarity;
	}
	public void setSimilarity(float similarity) {
		this.similarity = similarity;
	}
	
	

}
