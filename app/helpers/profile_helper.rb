# © Copyright 2009 AfterClassroom.com — All Rights Reserved
module ProfileHelper
  def item_favorite(favorite)
    type = favorite.favorable_type
    case type
      when "Post"
      post = Post.find(favorite.favorable_id)
      post_type = post.type_name
      case post_type
        when "PostAssignment"
        render :partial => "/post_assignments/item", :locals => {:post => post, :title => post.title, :description => post.description, :controller_name => "post_assignments"}
        when "PostTest"
        render :partial => "/post_tests/item", :locals => {:post => post, :title => post.title, :description => post.description, :controller_name => "post_tests"}
        when "PostProject"
        render :partial => "/post_projects/item", :locals => {:post => post, :title => post.title, :description => post.description, :controller_name => "post_projects"}
        when "PostExam"
        render :partial => "/post_exams/item", :locals => {:post => post, :title => post.title, :description => post.description, :controller_name => "post_exams"}
        when "PostEvent"
        render :partial => "/post_events/item", :locals => {:post => post, :title => post.title, :description => post.description, :controller_name => "post_events"}
        when "PostQa"
        render :partial => "/post_qas/item", :locals => {:post => post, :title => post.title, :description => post.description, :controller_name => "post_qas"}
        when "PostTutor"
        render :partial => "/post_tutors/item", :locals => {:post => post, :title => post.title, :description => post.description, :controller_name => "post_tutors"}
        when "PostBook"
        render :partial => "/post_books/item", :locals => {:post => post, :title => post.title, :description => post.description, :controller_name => "post_books"}
        when "PostJob"
        render :partial => "/post_jobs/item", :locals => {:post => post, :title => post.title, :description => post.description, :controller_name => "post_jobs"}
        when "PostParty"
        render :partial => "/post_parties/item", :locals => {:post => post, :title => post.title, :description => post.description, :controller_name => "post_parties"}
        when "PostAwareness"
        render :partial => "/post_awarenesses/item", :locals => {:post => post, :title => post.title, :description => post.description, :controller_name => "post_awarenesses"}
        when "PostExamSchedule"
        render :partial => "/post_exam_schedules/item", :locals => {:post => post, :title => post.title, :description => post.description, :controller_name => "post_exam_schedules"}
        when "PostHousing"
        render :partial => "/post_housings/item", :locals => {:post => post, :title => post.title, :description => post.description, :controller_name => "post_housings"}
        when "PostTeamup"
        render :partial => "/post_teamups/item", :locals => {:post => post, :title => post.title, :description => post.description, :controller_name => "post_teamups"}
        when "PostMyx"
        render :partial => "/post_myxes/item", :locals => {:post => post, :title => post.title, :description => post.description, :controller_name => "post_myxes"}
        when "PostFood"
        render :partial => "/post_foods/item", :locals => {:post => post, :title => post.title, :description => post.description, :controller_name => "post_foods"}
      end
      when "Story"
      story = Story.find(favorite.favorable_id)
      render :partial => "/stories/item", :locals => {:story => story}
      when "Photo"
      when "Music"
      when "video"
    end
  end
end
