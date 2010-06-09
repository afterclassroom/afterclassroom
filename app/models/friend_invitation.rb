require 'digest/sha1'
class FriendInvitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :became_user, :foreign_key => "became_user_id", :class_name => "User"
  
  before_create :make_activation_code
  
  protected
  def make_activation_code
    self.invitation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
end