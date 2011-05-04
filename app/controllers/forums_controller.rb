# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class ForumsController < ApplicationController

  def index  
    @text = "test from forum"
    @forums = Forum.find(:all).paginate(:page => params[:page], :per_page => 8, :order => "created_at")
  end

  def savecmt

    puts "heLLO WORLD"
    puts "heLLO WORLD"
    puts "heLLO WORLD"
    puts "heLLO WORLD"
    puts "heLLO WORLD"
    puts "heLLO WORLD"
    puts "heLLO WORLD"
    puts "heLLO WORLD"
    puts "heLLO WORLD"
    puts "heLLO WORLD"
    puts "heLLO WORLD"

    comment = params[:comment]
    commentable_id = params[:commentable_id]
    commentable_type = params[:commentable_type]
 

    puts "heLLO WORLD"
    render :text => "text from save_cmt "+params[:content]
  end

end
