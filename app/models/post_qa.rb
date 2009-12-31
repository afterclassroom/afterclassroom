class PostQa < ActiveRecord::Base
  # Relations
  belongs_to :post_qa_category
  belongs_to :post
end
