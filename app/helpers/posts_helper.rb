# © Copyright 2009 AfterClassroom.com — All Rights Reserved
module PostsHelper
  def show_post(post)
    post_category_name = post.post_category.name
    case post_category_name
    when "Education"
      link_to "Show", post.post_education
    when "Tutors"
      link_to "Show", post.post_tutor
    when "Books"
      link_to "Show", post.post_book
    when "Jobs"
      link_to "Show", post.post_job
    when "Party"
      link_to "Show", post.post_party
    when "Student Awareness"
      link_to "Show", post.post_awareness
    when "Housing"
      link_to "Show", post.post_housing
    when "Team Up"
      link_to "Show", post.post_teamup
    else
      link_to "Show", post
    end
  end

  def show_post_dialog(post)
    post_category_name = post.post_category.name
    case post_category_name
    when "Education"
      "/post_educations/show_dialog?id=" + post.id.to_s
    when "Tutors"
      "/post_tutors/show_dialog?id=" + post.id.to_s
    when "Books"
      "/post_books/show_dialog?id=" + post.id.to_s
    when "Jobs"
      "/post_jobs/show_dialog?id=" + post.id.to_s
    when "Party"
      "/post_parties/show_dialog?id=" + post.id.to_s
    when "Student Awareness"
      "/post_awarenesses/show_dialog?id=" + post.id.to_s
    when "Housing"
      "/post_housings/show_dialog?id=" + post.id.to_s
    when "Team Up"
      "/post_teamups/show_dialog?id=" + post.id.to_s
    else
      "/posts/show_dialog?id=" + post.id.to_s
    end
  end
  
  def edit_post(post)
    post_category_name = post.post_category.name
    case post_category_name
    when "Education"
      link_to "Edit", edit_post_education_path(post.post_education)
    when "Tutors"
      link_to "Edit", edit_post_tutor_path(post.post_tutor)
    when "Books"
      link_to "Edit", edit_post_book_path(post.post_book)
    when "Jobs"
      link_to "Edit", edit_post_job_path(post.post_job)
    when "Party"
      link_to "Edit", edit_post_party_path(post.post_party)
    when "Student Awareness"
      link_to "Edit", edit_post_awareness_path(post.post_awareness)
    when "Housing"
      link_to "Edit", edit_post_housing_path(post.post_housing)
    when "Team Up"
      link_to "Edit", edit_post_teamup_path(post.post_teamup)
    else
      link_to "Edit", edit_post_path(post)
    end
  end
end
