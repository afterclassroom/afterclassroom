# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Forum < ActiveRecord::Base
  belongs_to :user

  # Comments
  acts_as_commentable

  # Solr search index
  searchable do
    text :title, :default_boost => 2, :stored => true
    text :content, :stored => true
    integer :user_id, :references => User
    time :created_at
  end

  def self.paginated_forum_with_search(params)
      if params[:search_txt]
        query = params[:search_txt]
        Forum.search do
          fulltext query
          order_by :created_at, :desc
          paginate :page => 10, :per_page => 10
        end
      end
  end

end
