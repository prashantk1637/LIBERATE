package com.liberate;

public class ReturnStatusBean {
	private int accession_no;
	private String mem_id;
	private String mem_type;
	private String librarian_id;
	private String returned_approval;
	private String issue_date="";
	private String due_date="";
	private String return_date;
	private int fine_paid;
	
	public int getAccession_no() {
		return accession_no;
	}
	public void setAccession_no(int accession_no) {
		this.accession_no = accession_no;
	}
	public String getMem_id() {
		return mem_id;
	}
	public void setMem_id(String mem_id) {
		this.mem_id = mem_id;
	}
	public String getMem_type() {
		return mem_type;
	}
	public void setMem_type(String mem_type) {
		this.mem_type = mem_type;
	}
	public String getLibrarian_id() {
		return librarian_id;
	}
	public void setLibrarian_id(String librarian_id) {
		this.librarian_id = librarian_id;
	}
	public String getReturned_approval() {
		return returned_approval;
	}
	public void setReturned_approval(String returned_approval) {
		this.returned_approval = returned_approval;
	}
	public String getIssue_date() {
		return issue_date;
	}
	public void setIssue_date(String issue_date) {
		this.issue_date = issue_date;
	}
	public String getDue_date() {
		return due_date;
	}
	public void setDue_date(String due_date) {
		this.due_date = due_date;
	}
	public String getReturn_date() {
		return return_date;
	}
	public void setReturn_date(String return_date) {
		this.return_date = return_date;
	}
	public int getFine_paid() {
		return fine_paid;
	}
	public void setFine_paid(int fine_paid) {
		this.fine_paid = fine_paid;
	}
	

}
