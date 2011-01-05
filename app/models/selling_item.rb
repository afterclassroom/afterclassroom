class SellingItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :shopping_subcategory

  has_many :selling_item_images, :dependent => :destroy


  #Named scope
  scope :friend_item, lambda { |friend_ids| {:conditions => {:user_id => friend_ids}, :order => "created_at DESC" } }
  scope :with_sub_category, lambda { |sub_category| {:conditions => {:shopping_subcategory_id => sub_category}} }
  scope :recent, {:order => "created_at DESC"}

  def self.paginated_item_conditions_with_friend(params, friends_id)
    friendItems = self.friend_item(friends_id).with_sub_category(params[:subid])
    friendItems.paginate :page => params[:page], :per_page => 3
  end

  def self.paginated_item_conditions_with_recent(params)
    friendItems = self.recent.with_sub_category(params[:subid])
    friendItems.paginate :page => params[:page], :per_page => 4
  end


end
