# © Copyright 2009 AfterClassroom.com — All Rights Reserved
module ApplicationHelper
  include ActsAsTaggableOn::TagsHelper
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

    raw "<li class='#{link_current}' >" + link_to(raw("<span>" + name + "</span>"), url, {}) + "</li>"
  end

  def tab_to_admin(name, ctrl_name, path, sub_menus = nil)
    current_menu = "select"
    current_sub = ""
    current_item = @controller.action_name

    if ctrl_name.is_a?(Array)# Multi controllers on one menu
      current_menu = "current" if ctrl_name.include?(controller.controller_name)
      current_sub = "show"
      current_item = controller.controller_name
    else# One controller with multi action
      current_menu = "current" if ctrl_name == controller.controller_name
      current_sub = "show"
    end

    render :partial => "shared/admin/menu_item", :locals => {:name => name, :current_menu => current_menu, :current_sub => current_sub, :current_item => current_item, :path => path, :sub_menus => sub_menus}
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
    file = post.attach
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
      path = file_path ? file.url(:thumb) : "/images/icons/icon_defaut/icon_tutor.png"
    when "post_books"
      path = file_path ? "/images/icons/file_type/#{file_ext}.png" : "/images/icons/icon_defaut/icon_book.png"
    when "post_jobs"
      path = file_path ? "/images/icons/file_type/#{file_ext}.png" : "/images/icons/icon_defaut/icon_job.png"
    when "post_foods"
      path = file_path ? file.url(:thumb) : "/images/icons/icon_defaut/icon_food.png"
    when "post_parties"
      path = file_path ? file.url(:thumb) : "/images/icons/icon_defaut/icon_party.png"
    when "post_myxes"
      path = file_path ? file.url(:thumb) : "/images/icons/icon_defaut/icon_myx.png"
    when "post_awarenesses"
      path = file_path ? "/images/icons/file_type/#{file_ext}.png" : "/images/icons/icon_defaut/icon_awarenesse.png"
    when "post_housings"
      path = file_path ? file.url(:thumb) : "/images/icons/icon_defaut/icon_housing.png"
    when "post_teamups"
      path = file_path ? file.url(:thumb) : "/images/icons/icon_defaut/icon_teamup.png"
    when "post_exam_schedules"
      path = file_path ? "/images/icons/file_type/#{file_ext}.png" : "/images/icons/icon_defaut/icon_exam.png"
    else
      path = "/images/noimg.png"
    end
    image_tag path
  end

  def get_gender(sex)
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

  def show_image_user_post(user)
    link_to raw("<div>#{image_tag(user.avatar.url(:thumb))}</div>"), user_path(user)
  end

  def show_user_post(user)
    link_to user.full_name, user_path(user)
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
    when "post_exam_schedules"
      type = PostCategory.find_by_class_name("PostExamSchedule").id
      search_post_path = search_post_exam_schedules_path
    else
      type = PostCategory.find_by_class_name("PostAssignment").id
      search_post_path = search_post_assignments_path
    end
    render :partial => "shared/search_posts", :locals => {:type => type, :search_post_path => search_post_path, :query => query}
  end
  
  def link_to_edit_post(post)
    case post.type_name
    when "PostAssignment"
      link_edit = edit_post_assignment_url(post.post_assignment)
    when "PostProject"
      link_edit = edit_post_project_url(post.post_project)
    when "PostTest"
      link_edit = edit_post_test_url(post.post_test)
    when "PostExam"
      link_edit = edit_post_exam_url(post.post_exam)
    when "PostQa"
      link_edit = edit_post_qa_url(post.post_qa)
    when "PostTutor"
      link_edit = edit_post_tutor_url(post.post_tutor)
    when "PostBook"
      link_edit = edit_post_book_url(post.post_book)
    when "PostJob"
      link_edit = edit_post_job_url(post.post_job)
    when "PostFood"
      link_edit = edit_post_food_url(post.post_food)
    when "PostParty"
      link_edit = edit_post_party_url(post.post_party)
    when "PostMyx"
      link_edit = edit_post_myx_url(post.post_myx)
    when "PostAwareness"
      link_edit = edit_post_awareness_url(post.post_awareness)
    when "PostHousing"
      link_edit = edit_post_housing_url(post.post_housing)
    when "PostTeamup"
      link_edit = edit_post_teamup_url(post.post_teamup)
    when "PostExamSchedule"
      link_edit = edit_post_exam_schedule_url(post.post_exam)
    end
    return link_edit
  end

  def show_options(school, params, options = {})
    department = params[:department] if params[:department]
    year = params[:year] if params[:year]
    over = params[:over] ? params[:over] : "30"

    render :partial => "shared/options", :locals => {:school => school, :department => department, :year => year, :over => over, :options => options}
  end

  def show_post_comments(obj)
    render :partial => "shared/post_comments", :locals => {:obj => obj}
  end

  def show_student_lounge()
    if !logged_in?
      link_to_require_login("Student Lounge")
    else
      link_to "Student Lounge", user_student_lounges_path(current_user)
    end
  end

  def show_favorite(type, item)
    f_size = item.favoriting_users.size
    if !logged_in?
      link_to_require_login("Favorite (#{f_size})")
    elsif current_user.has_favorite?(item)
      str_favorited = "It`s already in your favourite list."
      link_to("Favorite (#{f_size})", "javascript:;", :class => "vtip", :title => str_favorited)
    else
      link_to "Favorite (#{f_size})", {:controller => "favorites", :action => "add_to_favorite", :item_id => item.id, :type => type }, :remote => true, :method => "get"
    end
  end

  def show_favorite_in_detail(type, item)
    f_size = item.favoriting_users.size
    if !logged_in?
      link_to_require_login(raw("<span id='favorite_action'>Favorite (#{f_size})</span>"))
    elsif current_user.has_favorite?(item)
      str_favorited = "It`s already in your favourite list."
      link_to(raw("<span id='favorite_action'>Favorite (#{f_size})</span>"), "javascript:;", :class => "vtip", :title => str_favorited)
    else
      link_to raw("<span>Favorite (#{f_size})</span>"), {:controller => "favorites", :action => "add_to_favorite_in_detail", :item_id => item.id, :type => type }, :remote => true, :method => "get"
    end
  end

  def show_email(post)
    if !logged_in?
      link_to_require_login(raw("<span>Email</span>"))
    else
      link_to(raw("<span>Email</span>"), "#{show_email_user_messages_path(current_user)}?recipient_id=#{post.user.id}&height=300&width=470", :class => "thickbox", :title => "Send to #{post.user.full_name}")
    end
  end

  def show_add_job(post)
    unless logged_in?
      link_to_require_login(raw("<span>Add job</span>"))
    else
      job_lists = current_user.jobs_lists
      link_to(raw("<span>Add job</span>"), {:remote => true, :update => "show_job_button"}, :url => { :action => "add_job", :post_job_id => post.id}) if !job_lists.collect{|j| j.post_job}.include?(post.post_job)
    end
  end

  def show_my_job_list(post)
    if !logged_in?
      link_to_require_login(raw("<span>My job list</span>"))
    else
      job_lists = current_user.jobs_lists
      link_to(raw("<span>My job list</span>"), "#{my_job_list_post_jobs_path}?height=400&width=470", :class => "thickbox", :title => "My job list") if job_lists.size > 0
    end
  end

  def show_apply_now()
    if !logged_in?
      link_to_require_login(raw("<span style='padding-left:10px'>Apply now</span>"))
    else
      return raw("<a title='Apply now' id='apply_now'>Apply now</a>")
    end
  end


  def show_add_party(post)
    if !logged_in?
      link_to_require_login(raw("<span>Add party</span>"))
    else
      party_lists = current_user.partys_lists
      link_to(raw("<span>Add party</span>"), :remote => true, :update => "show_party_button", :url => { :action => "add_party", :post_party_id => post.id}) if !party_lists.collect{|j| j.post_party}.include?(post.post_party)
    end
  end

  def show_my_party_list(post)
    if !logged_in?
      link_to_require_login(raw("<span>My party list</span>"))
    else
      party_lists = current_user.partys_lists
      link_to(raw("<span>My party list</span>"), "#{my_party_list_post_parties_path}?height=400&width=470", :class => "thickbox", :title => "My party list") if party_lists.size > 0
    end
  end

  def show_become_a_fan(user)
    str = ""
    if !logged_in?
      str = link_to_require_login(raw("<span>Become a Fan</span>"))
    else
      if user.fans.include?(current_user)
        str = "You are a fan"
      else
        str = link_to_function raw("<span>Become a Fan</span>"), "become_a_fan('#{become_a_fan_user_friends_path(current_user)}?user_id=#{user.id}')"
      end
    end
    return str
  end

  def show_invite_friend(user)
    str = ""
    if !logged_in?
      str = link_to_require_login(raw("<span>Invite Friend</span>"))
    else
      if current_user.user_friends.include?(user)
        str = "My friend"
      else
        if current_user.user_invites_out.find_by_user_id_target(user.id) || current_user.user_invites_in.find_by_user_id(user.id)
          str = "Waiting accept"
        else
          str = link_to(raw("<span>Invite Friend</span>"), "#{show_invite_user_friends_path(current_user)}?user_invite=#{user.id}&height=300&width=470", :class => "thickbox", :title => "Invite #{user.full_name} to be a friend")
        end
      end
    end
    return str
  end

  def show_invite_chat(user)
    str = ""
    if !logged_in?
      str = link_to_require_login(raw("<span>Invite Chat</span>"))
    else
      if user.check_user_online
        if user.check_user_in_chatting_session(current_user.id)
          str = "Chatting..."
        else
          str = link_to_function "Invite Chat", "invite_chat('#{user.id}')"
        end
      else
        str = "Offline"
      end
    end
    return str
  end

  def show_map(address, html)
    link_to("View map", "/gmaps?address=#{address}&html=#{html}&height=325&width=550", :class => "thickbox", :title => "View map")
  end

  def show_support(post)
    str = "Reliable"
    str = "Support" if post.post_awareness.awareness_type.label == "take_action_now"
    if !logged_in?
      link_to_require_login(str)
    elsif current_user.post_awarenesses_supports.collect{|p| p.post_awareness}.include?(post.post_awareness)
      str_supported = "You've selected."
      link_to(str, "javascript:;", :class => "vtip", :title => str_supported)
    else
      link_to(str, {:url => "#{support_post_awarenesses_path}?post_id=#{post.id}&support=1", :update => "support_action", :remote => true})
    end
  end

  def show_notsupport(post)
    str = "Not Reliable"
    str = "Not Support" if post.post_awareness.awareness_type.label == "take_action_now"
    if !logged_in?
      link_to_require_login(str)
    elsif current_user.post_awarenesses_supports.collect{|p| p.post_awareness}.include?(post.post_awareness)
      str_supported = "You've selected."
      link_to(str, "javascript:;", :class => "vtip", :title => str_supported)
    else
      link_to(str, {:url => "#{support_post_awarenesses_path}?post_id=#{post.id}&support=0", :update => "support_action", :remote => true})
    end
  end

  def show_go_back
    link_to raw("<span>Go back</span>"), session[:go_back_url]
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
      link_to numb, { :controller => ctrl_name, :action => "rate", :post_id => id, :rating => val_rate }, :remote => true
    end
  end

  def show_submit_rating(post_id, path)
    if !logged_in?
      link_to_require_login(raw("<span>Submit</span>"))
    else
      link_to(raw("<span>Submit</span>"), "javascript:;", :onclick => "requireRating('#{post_id}', '#{path}');")
    end
  end

  def show_submit_form
    if !logged_in?
      link_to_require_login(submit_tag("Submit"))
    else
      link_to(submit_tag("Submit"), "javascript:;", :onclick => "$('#form_post').submit();")
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
      image = link_to raw(image_tag(wall.user_wall_photo.link, :style => "width:92px;height:68px")), link, :target => "_blank"
      title = wall.user_wall_photo.title
      sub_content = wall.user_wall_photo.sub_content
    end

    if wall.user_wall_video
      link = wall.user_wall_video.link
      image = link_to image_tag(wall.user_wall_video.thumb, :style => "width:92px;height:68px") + raw("<span class='play'/>"), {:controller => "user_walls", :action => "jplayer_video", :wall_id => wall.id}, :remote => true
      title = wall.user_wall_video.title
      sub_content = wall.user_wall_video.sub_content
    end

    if wall.user_wall_music
      link = wall.user_wall_music.link
      image = link_to image_tag("/images/music.png", :style => "width:92px;height:68px") + raw("<span class='play'/>"), {:controller => "user_walls", :action => "jplayer_music", :wall_id => wall.id}, :remote => true
      title = wall.user_wall_music.title
      sub_content = wall.user_wall_music.sub_content
    end

    if wall.user_wall_link
      link = wall.user_wall_link.link
      image = link_to(raw(image_tag(wall.user_wall_link.image_link, :style => "width:92px;height:68px")), link, :target => "_blank") if wall.user_wall_link.image_link
      title = wall.user_wall_link.title
      sub_content = wall.user_wall_link.sub_content if wall.user_wall_link.sub_content
    end
    render :partial => "user_walls/wall_attach", :locals => {:wall_id => wall.id, :image => image, :title => title, :link => link, :sub_content => sub_content}
  end

  def gmap_key
    key = GMAP_KEY_SITE if Rails.env == 'production'
    key = GMAP_KEY_LOCAL if Rails.env == 'development'
    return key
  end

  def display_flash_messages_with_raw
    raw(display_flash_messages)
  end

  def textilize(text)
    Textilizer.new(text).to_html.html_safe unless text.blank?
  end

  private
  def link_to_require_login(str)
    link_to(str, "/login_ajax?height=300&width=540", :class => "thickbox", :title => "Sign In")
  end
end
