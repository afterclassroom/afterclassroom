class LearnToolCate < ActiveRecord::Base
  has_many :learntools, :dependent => :destroy
end
