# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class ForumsController < ApplicationController
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter, :except => [:index, :view_all_no_loggin, :see_all_top_fr, :search]
  before_filter :cas_user

  def index
    @forums = Forum.find(:all, :order => "created_at DESC").paginate(:page => params[:page], :per_page => 10, :order => "created_at")
    @top_frs = Forum.top_answer.paginate(:page => 1, :per_page => 10)
    
    if (flash[:warning] != "Captcha does not match.")
      session["open_form"] = "close"
    end
    
    #redirect_to :action => "index", :str_title => params[:txt_help], :str_cnt => params[:help_content]
  end

  def see_all_top_fr
    @top_frs = Forum.top_answer.paginate(:page => 1, :per_page => 10)
    @forums = Forum.top_answer.paginate(:page => params[:page], :per_page => 10)
    render :template => 'forums/index' 
  end

  def search
    @forums = Forum.paginated_forum_with_search(params).results
    @top_frs = Forum.top_answer.paginate(:page => 1, :per_page => 10)
    render :template => 'forums/index' 
  end

  def delcmt
    fr = Forum.find(params[:forum_id])
    comment = fr.comments.find(params[:comment_id])

    if fr.user == current_user or comment.user == current_user
      comment.destroy
    end

    render :text => fr.comments.size
  end
  
  def view_fr
    @fr = Forum.find(params[:forum_id])
    render :layout => false
  end
  
  def save_edit

    fr = Forum.find(params[:forum_id])

    fr.title = params[:txt_help]
    fr.content = params[:help_content]

    if fr.save
      flash[:warning] = "Update question successfully"
    else
      flash[:warning] = "Failed to update question"
    end 

    @forums = Forum.find(:all, :order => "created_at DESC").paginate(:page => params[:page], :per_page => 10, :order => "created_at")
    @top_frs = Forum.top_answer.paginate(:page => 1, :per_page => 10)
    
    redirect_to :action => "index"
  end
  
  def delfrm
    
    fr = Forum.find(params[:forum_id])
    fr.destroy
    
    render :text => 'Delete successfully'

  end

  def view_all_comments
    forum_id = params[:forum_id]
    @fr = Forum.find(forum_id)
    render :layout => false
  end

  def view_all_no_loggin
    forum_id = params[:forum_id]
    @fr = Forum.find(forum_id)
    render :layout => false
  end

  def savecmt
    @fr = Forum.find(params[:forum_id])

    comment = params[:comment]
    commentable_id = params[:commentable_id]
    commentable_type = params[:commentable_type]

    @obj_comment = Comment.new()
    @obj_comment.comment = params[:content]
    @obj_comment.user = current_user
    @obj_comment.save
    
    @fr.comments << @obj_comment
  end

  def addfr
    @new_fr = Forum.new()
    @new_fr.title = params[:txt_help]
    @new_fr.content = params[:help_content]
    @new_fr.user = current_user
    
    if simple_captcha_valid?   
      if @new_fr.save
        @status_message = "Add new question successfully"
        flash[:warning] = "Add new question successfully"
      else
        @status_message = "Failed to add new question"
      end 
      session["open_form"] = "close"
    else
      flash[:warning] = "Captcha does not match."
      session["open_form"] = "open"
      session["new_fr_title"] = params[:txt_help]
      session["new_fr_cnt"] = params[:help_content]
    end    
    
    redirect_to :action => "index"
  end

end
