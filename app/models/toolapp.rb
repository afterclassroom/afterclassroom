class Toolapp < ActiveRecord::Base
  acts_as_state_machine :initial => :recentlyadded, :column => 'state'
  # These are all of the states for the learning-tools.
  state :recentlyadded
  state :verified
  state :rejected

  event :accept do
    transitions :from => :recentlyadded, :to => :verified
  end

  event :reject do
    transitions :from => :recentlyadded, :to => :rejected
  end

  has_attached_file :toolphoto,
    :default_url => "/images/pictures/phone2.png",
    :styles => { :medium => "161x119>",
    :thumb => "90x66#" }
  validates_attachment_content_type :toolphoto, :content_type => ['image/jpg', 'image/jpeg', 'image/gif', 'image/png']
end
