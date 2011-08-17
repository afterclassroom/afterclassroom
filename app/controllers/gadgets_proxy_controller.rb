class GadgetsProxyController < ApplicationController
  def link
    url = params[:url]
    redirect_to url
  end
end