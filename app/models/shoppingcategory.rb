class Shoppingcategory < ActiveRecord::Base
  has_many :shopping_subcategories, :dependent => :destroy
end
