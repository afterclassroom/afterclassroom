# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class UserWallsController < ApplicationController
  before_filter :login_required
  
  def create_wall
    user_wall_id = params[:user_wall_id]
    your_mind = params[:your_mind]
    @user = User.find(user_wall_id)
    unless @user.nil?
      user_wall = UserWall.new
      user_wall.user_id_post = current_user.id
      user_wall.content = your_mind
      @user.user_walls << user_wall
      @user.save
    end
    @walls = @user.user_walls.find(:all, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
  end

  def create_comment
    wall_id = params[:wall_id]
    comment = params[:comment]

    @wall = UserWall.find_by_id(params[:wall_id])

    if @wall
      obj_comment = Comment.new()
      obj_comment.comment = comment
      obj_comment.user = current_user
      @wall.comments << obj_comment
    end
    render :layout => false
  end

  def link_image
  end

  def link_video
  end

  def link_music
  end

  def link_link
  end

  def attach_image
    link = params[:link]
    @user_wall_photo = UserWallPhoto.new
    @user_wall_photo.link = link
  end

  def attach_video
  end

  def attach_music
  end

  def attach_link
  end
end
