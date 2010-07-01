class FeedbackMailer < ActionMailer::Base
  
  def feedback(feedback)
    @recipients  = 'webmaster@yoursite.com'
    @from        = 'noreply@yoursite.com'
    @subject     = "[Feedback for YourSite] #{feedback.subject}"
    @sent_on     = Time.now
    @body[:feedback] = feedback    
  end

end
