class OmnitauthsController < ApplicationController
	before_filter :login_required, :only => ["destroy"]
  
	def create
		auth = request.env["omniauth.auth"]
    omnitauth = Omnitauth.find_by_provider_and_uid(auth['provider'], auth['uid'])
		if omnitauth
			self.current_user = omnitauth.user
			redirect_to user_student_lounges_path(self.current_user)
		elsif self.current_user
			self.current_user.omnitauths << Omnitauth.create(auth)
			redirect_back_or_default(root_path)
		else
			session[:auth] = auth
			redirect_to signup_url
		end
  end

  def destroy
    @omnitauth = Omnitauth.find(params[:id])
    @omnitauth.destroy
    redirect_back_or_default(root_path)
  end
end
