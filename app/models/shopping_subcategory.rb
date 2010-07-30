class ShoppingSubcategory < ActiveRecord::Base
  belongs_to :shoppingcategory
  has_many :selling_items, :dependent => :destroy
end
