class Phoneapplication < ActiveRecord::Base
  belongs_to :phoneappcategory

  has_attached_file :photo,
    :default_url => "/images/pictures/phone2.png",
    :styles => { :medium => "161x119>",
    :thumb => "90x66#" }

end
