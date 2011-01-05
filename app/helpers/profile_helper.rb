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
        render :partial => "/post_assignments/item", :locals => {:post => post, :title => post.title, :description => post.description}
      when "PostTest"
        render :partial => "/post_tests/item", :locals => {:post => post, :title => post.title, :description => post.description}
      when "PostProject"
        render :partial => "/post_projects/item", :locals => {:post => post, :title => post.title, :description => post.description}
      when "PostExam"
        render :partial => "/post_exams/item", :locals => {:post => post, :title => post.title, :description => post.description}
      when "PostQa"
        render :partial => "/post_qas/item", :locals => {:post => post, :title => post.title, :description => post.description}
      when "PostTutor"
        render :partial => "/post_tutors/item", :locals => {:post => post, :title => post.title, :description => post.description}
      when "PostBook"
        render :partial => "/post_books/item", :locals => {:post => post, :title => post.title, :description => post.description}
      when "PostJob"
        render :partial => "/post_jobs/item", :locals => {:post => post, :title => post.title, :description => post.description}
      when "PostParty"
        render :partial => "/post_parties/item", :locals => {:post => post, :title => post.title, :description => post.description}
      when "PostAwareness"
        render :partial => "/post_awarenesses/item", :locals => {:post => post, :title => post.title, :description => post.description}
      when "PostHousing"
        render :partial => "/post_housings/item", :locals => {:post => post, :title => post.title, :description => post.description}
      when "PostTeamup"
        render :partial => "/post_teamups/item", :locals => {:post => post, :title => post.title, :description => post.description}
      when "PostMyx"
        render :partial => "/post_myxes/item", :locals => {:post => post, :title => post.title, :description => post.description}
      when "PostFood"
        render :partial => "/post_foods/item", :locals => {:post => post, :title => post.title, :description => post.description}
      end
    when "Photo"
    when "Music"
    end
  end
end
