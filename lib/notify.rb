module Notify
  include ActiveSupport
  protected
  def send_notification(post)
    user = post.user
  end
end