class FacebooksController < ApplicationController
	def index
		session[:access_token] = Koala::Facebook::OAuth.new(Facebook::CALL_BACK.to_s).get_access_token(params[:code]) if params[:code]
	end
end
