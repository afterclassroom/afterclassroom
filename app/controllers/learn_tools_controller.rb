class LearnToolsController < ApplicationController
  layout 'student_lounge'
  
  def index
    @features = Learntool.paging_featured(params)
    @str_feature_page = "Page #{params[:feature_page]} of "+ ( Learntool.with_featured.size / 2 ).round.to_s
  end
  
  def mylearn
    
  end
end
