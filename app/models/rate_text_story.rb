class RateTextStory < ActiveRecord::Base
  belongs_to :user
  belongs_to :story
end
