class LearnToolsController < ApplicationController
  layout 'student_lounge'
  
  def index
    @features = Learntool.paging_featured(params)
  end
  
  def mylearn
    
  end
end
