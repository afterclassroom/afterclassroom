class Photo < ActiveRecord::Base
  
  
  belongs_to :user
end

class SpecialPhoto < Photo
end
