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

  # Named Scope

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

  def self.top_answer()
    objs = Forum.find_by_sql("select * from forums right join
(select commentable_id,count(commentable_id) as total from comments where commentable_type='Forum' group by commentable_id order by total DESC) as a
on forums.id = a.commentable_id
")

  end

end

