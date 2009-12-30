class PostQaCategory < ActiveRecord::Base
    # Validations
  
    # Relations
    has_many :post_qa
end
