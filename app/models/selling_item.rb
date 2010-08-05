class SellingItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :shopping_subcategory

  #Named scope
  named_scope :friend_item, lambda { |friend_ids| {:conditions => {:user_id => friend_ids} } }
#        ["selling_items.user_id = ?", current_user.user_friends.id]} }



end
