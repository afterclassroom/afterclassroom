# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class ForumsController < ApplicationController

  def index  
    @text = "test from forum"
    @forums = Forum.find(:all, :order => "created_at DESC").paginate(:page => params[:page], :per_page => 8, :order => "created_at")
  end

  def browse
    @forums = Forum.find(:all)
    #render :text => "HELLO WORLD"
    render :template => 'forums/index' 
  end

  def delcmt
    puts "DEL OPERATION::: comment_id == "+params[:comment_id]
    puts "DEL OPERATION:::: forum_id == "+params[:forum_id]
    puts "DEL OPERATION"
    puts "DEL OPERATION"
    puts "DEL OPERATION"
    puts "DEL OPERATION"
    puts "DEL OPERATION"
    puts "DEL OPERATION"
    puts "DEL OPERATION"
    puts "DEL OPERATION"
    puts "DEL OPERATION"
    puts "DEL OPERATION"
    render :text => "response from delcmt"
  end

  def view_all_comments
    forum_id = params[:forum_id]
    @fr = Forum.find(forum_id)
    render :layout => false
  end

  def savecmt
    @fr = Forum.find(params[:forum_id])

    comment = params[:comment]
    commentable_id = params[:commentable_id]
    commentable_type = params[:commentable_type]

    #can truyen forum id len theo
 

    @obj_comment = Comment.new()
    @obj_comment.comment = params[:content]
    @obj_comment.user = current_user
    @obj_comment.save

    @fr.comments << @obj_comment


    puts "after save comment :::: "+@fr.comments.length.to_s

    # render :text => "text from save_cmt "+params[:content]
  end

  def addfr
    puts "==============================="
    puts "==============================="
    puts "==============================="
    puts "==============================="
    puts "==============================="
    puts "==============================="
    puts "==============================="
    puts "==============================="
    puts "==============================="
    puts "==============================="
    puts "==============================="
    puts "==============================="
    @new_fr = Forum.new()
    @new_fr.title = params[:txt_help]
    @new_fr.content = params[:help_content]
    @new_fr.user = current_user

    if @new_fr.save
      @status_message = "Add new question successfully"
    else
      @status_message = "Failed to add new question"
    end 

    redirect_to :action => "index"
  end

end
