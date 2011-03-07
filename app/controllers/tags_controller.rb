# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class TagsController < ApplicationController
  respond_to :html, :xml 
  
  def index
  end
  
  def show_tags
    ctrl_name = params[:ctrl_name]
    class_name = params[:class_name]
    school = session[:your_school]
    tags = School.find(school).owned_tags.where(["taggable_type = ?", class_name])

    text = "<tags>"
    tags.each do |tg|
      text << "<a href='/#{ctrl_name}/tag/?tag_name=#{tg.name}' style='font-size: 12pt;'>#{tg.name}</a>"
    end
    text << "</tags>"
    
    render :xml => text
  end
  
  def show_tags_list
    class_name = params[:class_name]
    tag = params[:tag]
    school = session[:your_school]
    tags = School.find(school).owned_tags.where(["taggable_type = ? AND name LIKE ?", class_name, "%#{tag}%"])
    @tag_names = tags.collect{|t| t.name}
    render :layout => false
  end
end
