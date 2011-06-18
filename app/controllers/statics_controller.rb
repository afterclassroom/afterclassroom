class StaticsController < ApplicationController
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter, :except => [:index, :terms, :privacy]
  before_filter :cas_user
  def index
  end

  def terms
  end

  def privacy
  end
end
