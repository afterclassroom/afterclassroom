class PressInfo < ActiveRecord::Base
  belongs_to :user


  # Solr search index
  searchable do
    text :title, :default_boost => 2, :stored => true
    text :content, :stored => true
    integer :user_id, :references => User
    time :created_at
  end
  
  
  def self.paginated_press_with_search(params)
    if params[:search_content]
      query = params[:search_content]
      PressInfo.search do
        fulltext query
        order_by :created_at, :desc
        paginate :page => params[:page], :per_page => 1
      end
    end
  end
  
end
