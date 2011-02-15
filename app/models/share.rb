class Share < ActiveRecord::Base
  # Relations
  has_and_belongs_to_many :users
end
