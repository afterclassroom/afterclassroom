class ToolCategoriesController < ApplicationController
  require_role :admin
  layout 'admin'
  
  def index
    @tool_cates = LearnToolCate.find(:all)
  end
  
  def edit
    
  end
  
  def delete
    redirect_to :action => "index"
  end
  
  def save
    
  end
  
  def addnew
    @tool_cate = LearnToolCate.new
  end
  
  def create
    
  end
  
end
