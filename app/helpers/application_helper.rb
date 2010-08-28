# © Copyright 2009 AfterClassroom.com — All Rights Reserved
module ApplicationHelper
  include TagsHelper
  # Yield the content for a given block. If the block yiels nothing, the optionally specified default text is shown. 
  #
  #   yield_or_default(:user_status)
  #
  #   yield_or_default(:sidebar, "Sorry, no sidebar")
  #
  # +target+ specifies the object to yield.
  # +default_message+ specifies the message to show when nothing is yielded. (Default: "")
  def yield_or_default(message, default_message = "")
    message.nil? ? default_message : message
  end

  # Create tab.
  # 
  # The tab will link to the first options hash in the all_options array,
  # and make it the current tab if the current url is any of the options
  # in the same array.
  # 
  # +name+ specifies the name of the tab
  # +all_options+ is an array of hashes, where the first hash of the array is the tab's link and all others will make the tab show up as current.
  # 
  # If now options are specified, the tab will point to '#', and will never have the 'active' state.
  def tab_to(name, all_options = nil)
    url = all_options.is_a?(Array) ? all_options[0].merge({:only_path => false}) : "#"

    current_url = url_for(:action => @current_action, :only_path => false)
    link_current = ""

    if all_options.is_a?(Array)
      all_options.each do |o|
        if url_for(o.merge({:only_path => false})) == current_url
          link_current = "select"
          break
        end
      end  
    end

    "<li class='#{link_current}' >" + link_to("<span>" + name + "</span>", url, {}) + "</li>"
  end

  # Return true if the currently logged in user is an admin
  def admin?
    logged_in? && current_user.has_role?(:admin)
  end
  
  # Write a secure email adress
  def secure_mail_to(email)
    mail_to email, nil, :encode => 'javascript'
  end

  def action_to_text(activity)
    case activity.action
    when "updated_profile"
      "updated profile"
    when "updated_avatar"
      "updated avatar"
    when "post"
      post_category_name = Post.find(activity.item_id).post_category.name
      "posted " + post_category_name
    when "story"
      "shared a story"
    when "photo"
      "post a photo"
    when "music"
      "post a music"
    when "video"
      "post a video"
    end
  end

  def image_user_thumb(user_id)
    user = User.find(user_id)
    image_tag user.avatar.url(:thumb)
  end

  def image_post_thumb(ctrl_name, post)
    file_path = post.attach_file_name
    file_ext = File.extname(file_path).delete(".") if file_path
    case ctrl_name
    when "post_assignments"
      path = file_path ? "/images/icons/file_type/#{file_ext}.png" : "/images/icons/icon_defaut/icon_assignment.png"
    when "post_projects"
      path = file_path ? "/images/icons/file_type/#{file_ext}.png" : "/images/icons/icon_defaut/icon_project.png"
    when "post_tests"
      path = file_path ? "/images/icons/file_type/#{file_ext}.png" : "/images/icons/icon_defaut/icon_test.png"
    when "post_exams"
      path = file_path ? "/images/icons/file_type/#{file_ext}.png" : "/images/icons/icon_defaut/icon_exam.png"
    when "post_qas"
      path = "/images/icons/icon_defaut/icon_qa.png"
    when "post_tutors"
      path = file_path ?  file_path.url(:thumb) : "/images/icons/icon_defaut/icon_tutor.png"
    when "post_books"
      path = file_path ? "/images/icons/file_type/#{file_ext}.png" : "/images/icons/icon_defaut/icon_book.png"
    when "post_jobs"
      path = file_path ? "/images/icons/file_type/#{file_ext}.png" : "/images/icons/icon_defaut/icon_job.png"
    when "post_foods"
      path = file_path ? file_path.url(:thumb) : "/images/icons/icon_defaut/icon_food.png"
    when "post_parties"
      path = file_path ? file_path.url(:thumb) : "/images/icons/icon_defaut/icon_party.png"
    when "post_myxes"
      path = file_path ? file_path.url(:thumb) : "/images/icons/icon_defaut/icon_myx.png"
    when "post_awarenesses"
      path = file_path ? "/images/icons/file_type/#{file_ext}.png" : "/images/icons/icon_defaut/icon_awarenesse.png"
    when "post_housings"
      path = file_path ? file_path.url(:thumb) : "/images/icons/icon_defaut/icon_housing.png"
    when "post_teamups"
      path = file_path ? file_path.url(:thumb) : "/images/icons/icon_defaut/icon_teamup.png"
    else
      path = "/images/noimg.png"
    end
    image_tag path
  end

  def getGender(sex)
    if sex
      sex == true ? "Male" : "Female"
    else
      "N/A"
    end
  end
  
  def truncate_words(text, length = 30, end_string = '...')
    return if text.blank?
    words = strip_tags(text).split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end

  def show_search_form(ctrl_name, query)
    case ctrl_name
    when "post_assignments"
      type = PostCategory.find_by_class_name("PostAssignment").id
      search_post_path = search_post_assignments_path
    when "post_projects"
      type = PostCategory.find_by_class_name("PostProject").id
      search_post_path = search_post_projects_path
    when "post_tests"
      type = PostCategory.find_by_class_name("PostTest").id
      search_post_path = search_post_tests_path
    when "post_exams"
      type = PostCategory.find_by_class_name("PostExam").id
      search_post_path = search_post_assignments_path
    when "post_qas"
      type = PostCategory.find_by_class_name("PostQa").id
      search_post_path = search_post_qas_path
    when "post_tutors"
      type = PostCategory.find_by_class_name("PostTutor").id
      search_post_path = search_post_tutors_path
    when "post_books"
      type = PostCategory.find_by_class_name("PostBook").id
      search_post_path = search_post_books_path
    when "post_jobs"
      type = PostCategory.find_by_class_name("PostJob").id
      search_post_path = search_post_jobs_path
    when "post_foods"
      type = PostCategory.find_by_class_name("PostFood").id
      search_post_path = search_post_foods_path
    when "post_parties"
      type = PostCategory.find_by_class_name("PostParty").id
      search_post_path = search_post_parties_path
    when "post_myxes"
      type = PostCategory.find_by_class_name("PostMyx").id
      search_post_path = search_post_myxes_path
    when "post_awarenesses"
      type = PostCategory.find_by_class_name("PostAwareness").id
      search_post_path = search_post_awarenesses_path
    when "post_housings"
      type = PostCategory.find_by_class_name("PostHousing").id
      search_post_path = search_post_housings_path
    when "post_teamups"
      type = PostCategory.find_by_class_name("PostTeamup").id
      search_post_path = search_post_teamups_path
    else
      type = PostCategory.find_by_class_name("PostAssignment").id
      search_post_path = search_post_assignments_path
    end
    render :partial => "shared/search_posts", :locals => {:type => type, :search_post_path => search_post_path, :query => query}
  end

  def show_options(school, params, options = {})
    department = params[:department] if params[:department]
    year = params[:year] if params[:year]
    over = params[:over] ? params[:over] : "30"
    
    render :partial => "shared/options", :locals => {:school => school, :department => department, :year => year, :over => over, :options => options}
  end
  
  def show_favorite(type, item)
    f_size = item.favoriting_users.size
    if !logged_in?
      link_to_require_login("Favorite (#{f_size})")
    elsif current_user.has_favorite?(item)
      str_favorited = "It`s already in your favourite list."
      link_to("Favorite (#{f_size})", "javascript:;", :class => "vtip", :title => str_favorited)
    else
      link_to_remote "Favorite (#{f_size})", { :update => "item_favorite_#{item.id}", :url => {:controller => "favorites", :action => "add_to_favorite", :item_id => item.id, :type => type }, :method => "get" }
    end
  end

  def show_favorite_in_detail(type, item)
    f_size = item.favoriting_users.size
    if !logged_in?
      link_to_require_login("<span id='favorite_action'>Favorite (#{f_size})</span>")
    elsif current_user.has_favorite?(item)
      str_favorited = "It`s already in your favourite list."
      link_to("<span id='favorite_action'>Favorite (#{f_size})</span>", "javascript:;", :class => "vtip", :title => str_favorited)
    else
      link_to_remote "<span>Favorite (#{f_size})</span>", { :update => "item_favorite_#{item.id}", :url => {:controller => "favorites", :action => "add_to_favorite_in_detail", :item_id => item.id, :type => type }, :method => "get" }
    end
  end

  def show_email(post)
    if !logged_in?
      link_to_require_login("<span>Email</span>")
    else
      link_to("<span>Email</span>", "#{show_email_user_messages_path(post.user)}?user_id=#{post.user.id}&height=300&width=470", :class => "thickbox", :title => "Send to #{post.user.full_name}")
    end
  end

  def become_a_fan(post)
    if !logged_in?
      link_to_require_login("<span>Become a Fan</span>")
    else
      link_to("<span>Become a Fan</span>", "#{ become_a_fan_user_messages_path(post.user)}?user_id=#{post.user.id}&height=300&width=470", :class => "thickbox", :title => "Become a Fan of #{post.user.full_name}")
    end
  end

  def show_go_back
    link_to "<span>Go back</span>", session[:go_back_url]
  end

  # id : id of post
  # numb : number of rating
  # ctrl_name : name of controller
  # check_rated : check this post have rated(true or false)
  # val_rate : value of rating
  def show_rating(id, numb, ctrl_name, check_rated, val_rate)
    if !logged_in?
      link_to_require_login(numb)
    elsif check_rated
      link_to(numb, "javascript:;", :class => "vtip", :title => "#{configatron.str_rated}")
    else
      link_to_remote numb, { :update => "rate_#{id}", :url => {:controller => ctrl_name, :action => "rate", :post_id => id, :rating => val_rate } }
    end
  end
  
  def show_submit_rating(post_id, path)
    if !logged_in?
      link_to_require_login("<span>Submit</span>")
    else
      link_to("<span>Submit</span>", "javascript:;", :onclick => "requireRating('#{post_id}', '#{path}');")
    end
  end

  def show_submit_form
    if !logged_in?
      link_to_require_login("Submit")
    else
      link_to("Submit", "javascript:;", :onclick => "$('#form_post').submit();")
    end
  end

  def show_infor
    link_to("Edit Information", "#{edit_infor_user_profiles_path(current_user)}?height=350&width=470", :class => "thickbox", :title => "Edit Information")
  end

  def show_edu_infor
    link_to("Edit My Education", "#{edit_edu_infor_user_profiles_path(current_user)}?height=270&width=470", :class => "thickbox", :title => "Edit My Education")
  end

  def show_work_infor
    link_to("Edit My Work", "#{edit_work_infor_user_profiles_path(current_user)}?height=200&width=470", :class => "thickbox", :title => "Edit My Work")
  end

  def show_attach(wall)
    if wall.user_wall_photo
      link = wall.user_wall_photo.link
      image = link_to image_tag(wall.user_wall_photo.link, :style => "width:92px;height:68px"), link, :target => "_blank"
      title = wall.user_wall_photo.title
      sub_content = wall.user_wall_photo.sub_content
    end

    if wall.user_wall_video
      link = wall.user_wall_video.link
      image = link_to_remote image_tag(wall.user_wall_video.thumb, :style => "width:92px;height:68px") + "<span class='play'/>", :url => {:controller => "user_walls", :action => "jplayer_video", :wall_id => wall.id}, :update => "show_jplayer_#{wall.id}"
      title = wall.user_wall_video.title
      sub_content = wall.user_wall_video.sub_content
    end

    if wall.user_wall_music
      link = wall.user_wall_music.link
      image = link_to_remote image_tag("/images/music.png", :style => "width:92px;height:68px") + "<span class='play'/>", :url => {:controller => "user_walls", :action => "jplayer_music", :wall_id => wall.id}, :update => "show_jplayer_#{wall.id}"
      title = wall.user_wall_music.title
      sub_content = wall.user_wall_music.sub_content
    end

    if wall.user_wall_link
      link = wall.user_wall_link.link
      image = link_to image_tag(wall.user_wall_link.image_link, :style => "width:92px;height:68px"), link, :target => "_blank"
      title = wall.user_wall_link.title
      sub_content = wall.user_wall_link.sub_content
    end
    render :partial => "user_walls/wall_attach", :locals => {:wall_id => wall.id, :image => image, :title => title, :link => link, :sub_content => sub_content}
  end
  
  private
  def link_to_require_login(str)
    link_to(str, "/login_ajax?height=300&width=540", :class => "thickbox", :title => "Sign In")
  end

end
