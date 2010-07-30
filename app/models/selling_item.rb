class SellingItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :shopping_subcategory

end
