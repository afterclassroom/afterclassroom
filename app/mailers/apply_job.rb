class ApplyJob < ActionMailer::Base
  default :from => "technical@afterclassroom.com"
  default_url_options[:host] = "afterclassroom.com"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.qa_send_mail.refer_to_expert.subject
  #
  def apply_now(user_apply_id, post_id, file_path)
    
    @post = Post.find(post_id)
    @user = User.find(user_apply_id)
    @file_attach = file_path
    mail :to => @post.user.email, :subject => "Apply job: #{@post.title}"
    
  end
end
