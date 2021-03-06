class FeedbackMailer < ActionMailer::Base
  
  def feedback(feedback)
    @recipients  = 'info@afterclassroom.com'
    @from        = 'noreply@afterclassroom.com'
    @subject     = "[Feedback for YourSite] #{feedback.subject}"
    @sent_on     = Time.now
    @body[:feedback] = feedback    
  end

end
