class OmnitauthsController < ApplicationController
  def create
		auth = request.env["omniauth.auth"]
    omnitauth = Omnitauth.find_by_provider_and_uid(auth['provider'], auth['uid'])
    redirect_to "/"
  end

  def destroy
    @omnitauth = Omnitauth.find(params[:id])
    @omnitauth.destroy
    redirect_to omnitauths_url, :notice => "Successfully destroyed omnitauth."
  end
end
