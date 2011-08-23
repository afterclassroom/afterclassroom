class ToolCategoriesController < ApplicationController
  require_role :admin
  layout 'admin'
  
  def index
    @tool_cates = LearnToolCate.find(:all)
  end
  
end
