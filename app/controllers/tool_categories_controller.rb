class ToolCategoriesController < ApplicationController
  require_role :admin
  layout 'admin'
  
  def index
    @tool_cates = LearnToolCate.find(:all)
  end
  
  def edit
    @ct = LearnToolCate.find(params[:selectedID])
  end
  
  def delete
    ct = LearnToolCate.find(params[:selectedID])
    ct.destroy
    redirect_to :action => "index"
  end
  
  def saveedit
    ct = LearnToolCate.find(params[:ct_id])
    ct.update_attributes(params[:learn_tool_cate])
    ct.save

    redirect_to :action => "index"
  end
  
  def addnew
    @tool_cate = LearnToolCate.new
  end
  
  def savenew
    @tool_cate = LearnToolCate.new
    @tool_cate.title = params[:title]
    @tool_cate.description = params[:description]
    @tool_cate.save
    redirect_to :action => "index"
  end
  
end
