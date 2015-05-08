public with sharing class X311SearchController {
	public String searchTerm { get; set; }
	public List<KnowledgeArticleVersion> articleList { get; set; }
	
	public void doSearch() {
		String searchquery = 'FIND \'' + searchTerm + '*\'IN ALL FIELDS RETURNING KnowledgeArticleVersion(Id, title, UrlName, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\')';
		return;
	}
	
	//Page Size
	private Static Final Integer PAGE_NUMBER = 2;

	public X311SearchController() {
		String qryString = 'SELECT Id, title, UrlName, articleType, LastPublishedDate,LastModifiedById FROM KnowledgeArticleVersion WHERE (PublishStatus = \'online\' and Language = \'en_US\')';
		articleList= Database.query(qryString);
		maxSize = articleList.size() ;
	}

	//Keeps track of current page & max size of article list
	Integer currentPage = 1;
	Integer maxSize = 1;

	// Returns whether we need to see previous button or not
	public boolean getPrevRequired() {
		return currentPage > 1;
	}
	// Returns whether we need to see next button or not
	public boolean getNextRequired() {
		return currentPage * PAGE_NUMBER < maxSize;
	}
	//Returns current page number
	public Decimal getCurrentPageNumber() {
		return this.currentPage;
	}
	//action for next click
	public PageReference next() {
		if(maxSize > this.currentPage * PAGE_NUMBER) {
			this.currentPage = this.currentPage + 1;
		}
		return null;
	}

	//action for previous click
	public PageReference previous() {
		if(this.currentPage > 1) {
			this.currentPage = this.currentPage - 1;
		}
		return null;
	}	
}