class Feedback < ActiveRecord::Base
  validates_presence_of :comment
  attr_accessor :subject, :email, :comment    
  
  def initialize(params = {})
    super
    self.subject = params[:subject]
    self.email = params[:email]
    self.comment = params[:comment]
  end
  
  def valid?
    self.comment && !self.comment.strip.blank?
  end
  
end
