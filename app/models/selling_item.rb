class SellingItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :shopping_subcategory

  has_many :selling_item_images, :dependent => :destroy


  #Named scope
  named_scope :friend_item, lambda { |friend_ids| {:conditions => {:user_id => friend_ids}, :order => "created_at DESC" } }
  named_scope :with_sub_category, lambda { |sub_category| {:conditions => {:shopping_subcategory_id => sub_category}} }

  def self.paginated_item_conditions_with_friend(params, friends_id)
    friendItems = self.friend_item(friends_id).with_sub_category("1")
    friendItems.paginate :page => params[:page], :per_page => 3
  end

end
