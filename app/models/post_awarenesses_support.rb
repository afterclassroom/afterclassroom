class PostAwarenessesSupport < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :post_awareness
end
