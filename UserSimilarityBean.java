package recommendation;

public class UserSimilarityBean {
private String mem_id;
private String tag;
private float similarity;
public String getMem_id() {
	return mem_id;
}
public void setMem_id(String mem_id) {
	this.mem_id = mem_id;
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
