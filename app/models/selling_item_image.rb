class SellingItemImage < ActiveRecord::Base

  belongs_to :selling_item

  has_attached_file :selling_item_photo,
    :default_url => "/images/pictures/car1.png",
    :styles => { :medium => "427x319>",
    :thumb => "111x82#" }
  validates_attachment_content_type :selling_item_photo, :content_type => ['image/jpg', 'image/jpeg', 'image/gif', 'image/png']


end
