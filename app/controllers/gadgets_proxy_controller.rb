class GadgetsProxyController < ApplicationController
  def link
    url = params[:url]
    redirect_to URI.encode(url.strip)
  end
end
