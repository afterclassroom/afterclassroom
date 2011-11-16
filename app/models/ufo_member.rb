class UfoMember < ActiveRecord::Base
  belongs_to :user
  belongs_to :ufo

end
