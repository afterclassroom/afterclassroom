# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class TagsController < ApplicationController
  
  def index
  end

  def show_tags
    class_name = params[:class_name]
    case class_name
    when "PostQa"
      @tags = PostQa.tag_counts_on(:tags)
    when "PostAwareness"
      #@tags = PostAwareness.tag_counts_on(:tags)
    when "PostAssignment"
      #@tags = PostAssignment.tag_counts_on(:tags)
    when "PostFood"
      #@tags = PostFood.tag_counts_on(:tags)
    when "PostHousing"
      #@tags = PostHousing.tag_counts_on(:tags)
    when "PostTest"
      #@tags = PostTest.tag_counts_on(:tags)
    when "PostBook"
      #@tags = PostBook.tag_counts_on(:tags)
    when "PostTutor"
      #@tags = PostTutor.tag_counts_on(:tags)
    when "PostParty"
      #@tags = PostParty.tag_counts_on(:tags)
    when "PostMyx"
      #@tags = PostMyx.tag_counts_on(:tags)
    when "PostTeamup"
      #@tags = PostTeamup.tag_counts_on(:tags)
    when "PostExam"
      #@tags = PostExam.tag_counts_on(:tags)
    when "PostJob"
      #@tags = PostJob.tag_counts_on(:tags)
    when "PostExamSchedule"
      #@tags = PostExamSchedule.tag_counts_on(:tags)
    when "PostProject"
      #@tags = PostProject.tag_counts_on(:tags)
    end
    render :layout => false
  end
end
