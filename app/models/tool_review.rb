class ToolReview < ActiveRecord::Base
  belongs_to :user
  belongs_to :learntool
end
