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
    file_path = post.attach_file_name
    if post.attach_content_type =~ /^image.*/
      path = post.attach.url(:thumb)
    else
      file_ext = File.extname(file_path).delete(".") if file_path
      path = "/images/icons/file_type/#{file_ext}.png"
    end
    
    case ctrl_name
      when "post_assignments"
      path = file_path ? path : "/images/icons/icon_defaut/icon_assignment.png"
      when "post_projects"
      path = file_path ? path : "/images/icons/icon_defaut/icon_project.png"
      when "post_tests"
      path = file_path ? path : "/images/icons/icon_defaut/icon_test.png"
      when "post_exams"
      path = file_path ? path : "/images/icons/icon_defaut/icon_exam.png"
      when "post_events"
      path = file_path ? path : "/images/icons/icon_defaut/icon_event.png"
      when "post_qas"
      path = "/images/icons/icon_defaut/icon_qa.png"
      when "post_tutors"
      path = file_path ? path : "/images/icons/icon_defaut/icon_tutor.png"
      when "post_books"
      path = file_path ? path : "/images/icons/icon_defaut/icon_book.png"
      when "post_jobs"
      path = file_path ? path : "/images/icons/icon_defaut/icon_job.png"
      when "post_foods"
      path = file_path ? path : "/images/icons/icon_defaut/icon_food.png"
      when "post_parties"
      path = file_path ? path : "/images/icons/icon_defaut/icon_party.png"
      when "post_myxes"
      path = file_path ? path : "/images/icons/icon_defaut/icon_myx.png"
      when "post_awarenesses"
      path = file_path ? path : "/images/icons/icon_defaut/icon_awarenesse.png"
      when "post_housings"
      path = file_path ? path : "/images/icons/icon_defaut/icon_housing.png"
      when "post_teamups"
      path = file_path ? path : "/images/icons/icon_defaut/icon_teamup.png"
      when "post_exam_schedules"
      path = file_path ? path : "/images/icons/icon_defaut/icon_exam.png"
    else
      path = "/images/noimg.png"
    end
    image_tag path
  end
  
  def get_gender(sex)
    if sex != nil
      if sex == true
        "Male"
      else
        "Female"
      end
    else
      "N/A"
    end
    #    if sex
    #      sex == true ? "Male" : "Female"
    #    else
    #      "N/A"
    #    end
  end
  
  def truncate_words(text, length = 30, end_string = '...')
    return if text.blank?
    words = strip_tags(text).split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end
  
  def show_image_user_post(user)
    path = logged_in? ? show_lounge_user_path(user) : user_path(user)
    link_to raw("<div>#{image_tag(user.avatar.url(:thumb), :class => "vtip avatar_#{user.id}", :title => user.name)}</div>"), path
  end
  
  def show_image_teach_of_myx(post_myx)
    img = "/images/icons/icon_defaut/icon_members.png"
    img = post_myx.post.attach.url(:thumb) if post_myx.post.attach_file_name and post_myx.post.attach_content_type == "image/jpeg"
    link_to raw("<div>#{image_tag(img, :class => "vtip", :title => post_myx.professor)}</div>"), post_myx_path(post_myx)
  end
  
  def show_user_post(user)
    path = logged_in? ? show_lounge_user_path(user) : user_path(user)
    link_to user.full_name, path
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
      search_post_path = search_post_exams_path
      when "post_events"
      type = PostCategory.find_by_class_name("PostEvent").id
      search_post_path = search_post_events_path
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
      when "PostEvent"
      link_edit = edit_post_event_url(post.post_event)
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
      link_edit = edit_post_exam_schedule_url(post.post_exam_schedule)
    end
    return link_edit
  end
  
  def link_to_show_post(post)
    case post.type_name
      when "PostAssignment"
      link_show = post_assignment_url(post.post_assignment)
      when "PostProject"
      link_show = post_project_url(post.post_project)
      when "PostTest"
      link_show = post_test_url(post.post_test)
      when "PostExam"
      link_show = post_exam_url(post.post_exam)
      when "PostEvent"
      link_show = post_event_url(post.post_event)
      when "PostQa"
      link_show = post_qa_url(post.post_qa)
      when "PostTutor"
      link_show = post_tutor_url(post.post_tutor)
      when "PostBook"
      link_show = post_book_url(post.post_book)
      when "PostJob"
      link_show = post_job_url(post.post_job)
      when "PostFood"
      link_show = post_food_url(post.post_food)
      when "PostParty"
      link_show = post_party_url(post.post_party)
      when "PostMyx"
      link_show = post_myx_url(post.post_myx)
      when "PostAwareness"
      link_show = post_awareness_url(post.post_awareness)
      when "PostHousing"
      link_show = post_housing_url(post.post_housing)
      when "PostTeamup"
      link_show = post_teamup_url(post.post_teamup)
      when "PostExamSchedule"
      link_show = post_exam_schedule_url(post.post_exam_schedule)
    end
    return link_show
  end
  
  def get_controler_name_from_class_name(class_name)
    case class_name
      when "PostAssignment"
      controler_name = "post_assignments"
      when "PostProject"
      controler_name = "post_projects"
      when "PostTest"
      controler_name = "post_tests"
      when "PostExam"
      controler_name = "post_exams"
      when "PostEvent"
      controler_name = "post_events"
      when "PostQa"
      controler_name = "post_qas"
      when "PostTutor"
      controler_name = "post_tutors"
      when "PostBook"
      controler_name = "post_books"
      when "PostJob"
      controler_name = "post_jobs"
      when "PostFood"
      controler_name = "post_foods"
      when "PostParty"
      controler_name = "post_parties"
      when "PostMyx"
      controler_name = "post_myxes"
      when "PostAwareness"
      controler_name = "post_awarenesses"
      when "PostHousing"
      controler_name = "post_housings"
      when "PostTeamup"
      controler_name = "post_teamups"
      when "PostExamSchedule"
      controler_name = "post_exam_schedules"
    end
    return controler_name
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
  
  def show_post_comments_video(obj)
    render :partial => "shared/post_comments_video", :locals => {:obj => obj}
  end
  
  def show_post_comments_ShPo(obj)
    render :partial => "shared/post_comments_ShPo", :locals => {:obj => obj}
  end
  
  def show_student_lounge()
    if !logged_in?
      link_to_require_login("Student Lounge")
    else
      link_to "Student Lounge", user_student_lounges_path(current_user)
    end
  end
  
  def show_post(path)
    if !logged_in?
      link_to_require_login("Post")
    else
      link_to "Post", path
    end
  end
  
  def show_submit_form()
    if !logged_in?
      link_to_require_login('Submit')
    else
      link_to(submit_tag("Submit"), "javascript:;", :onclick => "request_form_submit();")
    end
  end
  
  def show_comment_button(post_id, comments)
    text = raw("Comments (<span id='post_#{post_id}_comments'>#{comments}</span>)")
    if !logged_in?
      link_to_require_login(text)
    else
      link_to text, "javascript:;", :onclick => "showListPostComment(#{post_id})"
    end
  end
  
  def show_answer_button(post_id, comments)
    text = raw("Answers (<span id='post_#{post_id}_comments'>#{comments}</span>)")
    if !logged_in?
      link_to_require_login(text)
    else
      link_to text, "javascript:;", :onclick => "showListPostComment(#{post_id})"
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
      link_to(raw("<span>Email</span>"), "#{show_email_user_messages_path(current_user)}?recipient_id=#{post.user.id}&height=270&width=470", :class => "thickbox", :title => "Send to #{post.user.full_name}")
    end
  end
  
  def show_add_job(post)
    unless logged_in?
      link_to_require_login(raw("<span>Add job</span>"))
    else
      job_lists = current_user.jobs_lists
      link_to(raw("<span>Add job</span>"), { :action => "add_job", :post_job_id => post.id}, :remote => true) if !job_lists.collect{|j| j.post_job}.include?(post.post_job)
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
      return raw("<a title='Save all' id='apply_now'>Apply now</a>")
    end
  end
  
  def show_add_party(post)
    if !logged_in?
      link_to_require_login(raw("<span>Add party</span>"))
    else
      party_lists = current_user.partys_lists
      link_to(raw("<span>Add party</span>"), { :action => "add_party", :post_party_id => post.id}, :remote => true) if !party_lists.collect{|j| j.post_party}.include?(post.post_party)
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
  
  def show_rsvp(post)
    if !logged_in?
      link_to_require_login(raw("<span>RSVP</span>"))
    else
      link_to(raw("<span>RSVP</span>")  , "#{show_rsvp_post_parties_path}?post_id=#{post.id}&height=380&width=490", :class => "thickbox", :title => "RSVP")
    end
  end
  
  def show_become_a_fan(user)
    str = ""
    if !logged_in?
      str = link_to_require_login(raw("<span>Become a Fan</span>"))
    else
      if user.fans.map(&:user_id).include?(current_user.id)
        str = "You are a fan"
      else
        str = link_to_function raw("<span>Become a Fan</span>"), "become_a_fan('#{become_a_fan_user_friends_path(current_user)}?fan_id=#{user.id}')"
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
        str = link_to(raw("<span>My friend</span>"), "javascript:;")
      else
        if current_user.user_invites_out.find_by_user_id_target(user.id) || current_user.user_invites_in.find_by_user_id(user.id)
          if current_user.user_invites_out.find_by_user_id_target(user.id)
            str = link_to(raw("<span>Waiting accept</span>"), "javascript:;")
          else
            i = current_user.user_invites_in.find_by_user_id(user.id)
            str = raw("<span id='friend_request_#{i.id}'>" + link_to("Accept", accept_user_friends_path(current_user, :invite_id => i.id), :remote => true, :style=>"margin-bottom:5px") + " " + link_to("No Accept", de_accept_user_friends_path(current_user, :invite_id => i.id), :remote => true) + "</span>")
          end
        else
          str = link_to(raw("<span id='friend_#{user.id}'>Invite Friend</span>"), "#{show_invite_user_friends_path(current_user)}?user_invite=#{user.id}&height=300&width=470", :id => "link_invite", :class => "thickbox", :title => "Invite #{user.full_name} to be a friend")
        end
      end
    end
    return str
  end
  
  def show_invite_friend_on_user_profile(user)
    str = ""
    if !logged_in?
      str = link_to_require_login(raw("<span class='span1'><span class='span2'>Invite Friend</span></span>"))
    else
      if current_user.user_friends.include?(user)
        str = link_to(raw("<span class='span1'><span class='span2'>My friend</span></span>"), "javascript:;")
      else
        if current_user.user_invites_out.find_by_user_id_target(user.id) || current_user.user_invites_in.find_by_user_id(user.id)
          str = link_to(raw("<span class='span1'><span class='span2'>Waiting accept</span></span>"), "javascript:;")
        else
          str = link_to(raw("<span class='span1'><span class='span2' id='friend_#{user.id}'>Invite Friend</span></span>"), "#{show_invite_user_friends_path(current_user)}?user_invite=#{user.id}&height=300&width=470", :id => "link_invite", :class => "thickbox", :title => "Invite #{user.full_name} to be a friend")
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
          str = link_to "Invite Chat", "/student_lounges/invite_chat?user_id=#{user.id}"
        end
      else
        str = "Offline"
      end
    end
    return str
  end
  
  def show_invite_chat_from_chat_page(user)
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
    link_to(raw("<span>View map</span>"), "/gmaps?address=#{address}&html=#{html}?height=375&amp;width=450&amp;inlineId=gmap", :class => "thickbox", :title => "View map")  
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
      link_to(str, "#{support_post_awarenesses_path}?post_id=#{post.id}&support=1", :remote => true)
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
      link_to(str, "#{support_post_awarenesses_path}?post_id=#{post.id}&support=0", :remote => true)
    end
  end
  
  def show_go_back
    link_to raw("<span>Go back</span>"), "javascript:history.back();"
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
  
  def show_infor
    link_to("Edit Information", "#{edit_infor_user_profiles_path(current_user)}?height=350&width=470", :class => "thickbox", :title => "Edit Information")
  end
  
  def show_edu_infor
    link_to("Edit My Education", "#{edit_edu_infor_user_profiles_path(current_user)}?height=270&width=470", :class => "thickbox", :title => "Edit My Education")
  end
  
  def show_work_infor
    link_to("Edit My Work", "#{edit_work_infor_user_profiles_path(current_user)}?height=200&width=470", :class => "thickbox", :title => "Edit My Work")
  end
  
  def show_status_setting(user, type)
    pr = user.private_settings.where(:type_setting => type).first
    
    str = pr ? Hash[OPTIONS_SETTING.map {|x| [x[0], x[1]]}].key(pr.share_to) : "Private"
    "Share to: " + str
  end
  
  def show_options_setting(user, type)
    pr = user.private_settings.where(:type_setting => type).first
    val = pr ? pr.share_to : 0
    select_tag "#{type}", options_for_select(OPTIONS_SETTING, val), :class => "menuPrivate"
  end
  
  def show_attach(wall)
    if wall.user_wall_photo
      link = wall.user_wall_photo.sub_content
      img_link = link_to(raw(image_tag("/gadgets_proxy/link?url=#{wall.user_wall_photo.link}", :style => "width:92px;height:68px")), wall.user_wall_photo.link, :target => "_blank", :class => "imageLink")
      image = get_image_wall(wall.id, img_link)
      title = wall.user_wall_photo.title
      sub_content = ""
    end
    
    if wall.user_wall_video
      link = "/gadgets_proxy/link?url=#{wall.user_wall_video.link}"
      img_link = link_to image_tag(wall.user_wall_video.thumb, :style => "width:92px;height:68px") + raw("<span class='play'/>"), {:controller => "user_walls", :action => "jplayer_video", :wall_id => wall.id}, :remote => true
      image = get_image_wall(wall.id, img_link)
      title = wall.user_wall_video.title
      sub_content = raw(wall.user_wall_video.sub_content)
    end
    
    if wall.user_wall_music
      link = wall.user_wall_music.sub_content
      img_link = link_to image_tag("/images/music.png", :style => "width:92px;height:68px") + raw("<span class='play_music'/>"), {:controller => "user_walls", :action => "jplayer_music", :wall_id => wall.id}, :remote => true
      image = get_image_wall(wall.id, img_link)
      title = wall.user_wall_music.title
      sub_content = ""
    end
    
    if wall.user_wall_link
      link = wall.user_wall_link.link
      if wall.user_wall_link.image_link
        img_link = link_to(raw(image_tag(wall.user_wall_link.image_link, :style => "width:92px;height:68px")), link, :target => "_blank")
        image = get_image_wall(wall.id, img_link)
      end
      title = wall.user_wall_link.title
      sub_content = raw(wall.user_wall_link.sub_content) if wall.user_wall_link.sub_content
    end
    
    if wall.user_wall_post
      post_type = wall.user_wall_post.post_type
      post_id = wall.user_wall_post.post_id
      
      begin
        obj = eval(post_type).find(post_id)
      rescue
        obj = nil
      end
      
      if obj
        case post_type
          when "PhotoAlbum"
          if obj.photos.size > 0
            s = obj.photos.size < 4 ? obj.photos.size : 4
            i = 0 
            image = ""
            obj.photos.each do |p|
              img_link = link_to(raw(image_tag(p.photo_attach.url(:thumb), :style => "width:92px;height:68px")), show_photo_album_user_url(obj.user, :photo_album_id => obj), :class => "iframe")
              image << get_image_wall(wall.id, img_link)
              i = i + 1
              break if i == s
            end
          end
          when "Photo"
          link = user_photo_url(obj.user, obj)
          img_link = link_to(raw(image_tag(obj.photo_attach.url(:thumb), :style => "width:92px;height:68px")), obj.photo_attach.url, :class => "imageLink", :target => "_blank")
          image = get_image_wall(wall.id, img_link)
          title = obj.title
          sub_content = truncate_words(obj.description)
          when "MusicAlbum"
          link = show_music_album_user_url(obj.user, :music_album_id => obj)
          img_link = link_to image_tag(obj.music_album_attach.url(:thumb), :style => "width:92px;height:68px") + raw("<span class='play_music'/>"), {:controller => "user_walls", :action => "jplayer_music", :wall_id => wall.id}, :remote => true
          image = get_image_wall(wall.id, img_link)
          title = obj.name
          when "Music"
          link = user_music_url(obj.user, obj)
          img_link = link_to image_tag(obj.music_album.music_album_attach.url(:thumb), :style => "width:92px;height:68px") + raw("<span class='play_music'/>"), {:controller => "user_walls", :action => "jplayer_music", :wall_id => wall.id}, :remote => true
          image = get_image_wall(wall.id, img_link)
          title = obj.title
          when "Video"
          link = get_video_path(obj.video_file.video_attach.url)
          img_link = link_to image_tag(obj.video_file.video_attach.url(:medium), :style => "width:92px;height:68px") + raw("<span class='play'/>"), {:controller => "user_walls", :action => "jplayer_video", :wall_id => wall.id}, :remote => true
          image = get_image_wall(wall.id, img_link)
          title = obj.title
          sub_content = obj.description
          when "Story"
          link = user_story_path(obj.user, obj)
          if display_image(obj) != ""
            img_link = link_to display_image(obj, {:style => "width:92px;height:68px"}), link, :target => "_blank"
            image = get_image_wall(wall.id, img_link)
          end
          title = obj.title
          sub_content = truncate_words(obj.content)
          when "PostAssignment"
          link = post_assignment_path(obj)
          img_link = link_to image_post_thumb("post_assignments", obj.post), link, :target => "_blank"
          image = '<div class="assImg"><div>' + img_link + '</div></div>'
          title = obj.post.title
          sub_content = truncate_html(obj.post.description, :length => 100, :omission => '...')
          when "PostProject"
          link = post_project_path(obj)
          img_link = link_to image_post_thumb("post_projects", obj.post), link, :target => "_blank"
          image = '<div class="assImg"><div>' + img_link + '</div></div>'
          title = obj.post.title
          sub_content = truncate_html(obj.post.description, :length => 100, :omission => '...')
          when "PostTest"
          link = post_test_path(obj)
          img_link = link_to image_post_thumb("post_tests", obj.post), link, :target => "_blank"
          image = '<div class="assImg"><div>' + img_link + '</div></div>'
          title = obj.post.title
          sub_content = truncate_html(obj.post.description, :length => 100, :omission => '...')
          when "PostExam"
          link = post_exam_path(obj)
          img_link = link_to image_post_thumb("post_exams", obj.post), link, :target => "_blank"
          image = '<div class="assImg"><div>' + img_link + '</div></div>'
          title = obj.post.title
          sub_content = truncate_html(obj.post.description, :length => 100, :omission => '...')
          when "PostEvent"
          link = post_event_path(obj)
          img_link = link_to image_post_thumb("post_events", obj.post), link, :target => "_blank"
          image = '<div class="assImg"><div>' + img_link + '</div></div>'
          title = obj.post.title
          sub_content = truncate_html(obj.post.description, :length => 100, :omission => '...')
          when "PostQa"
          link = post_qa_path(obj)
          img_link = link_to image_post_thumb("post_qas", obj.post), link, :target => "_blank"
          image = '<div class="assImg"><div>' + img_link + '</div></div>'
          title = obj.post.title
          sub_content = truncate_html(obj.post.description, :length => 100, :omission => '...')
          when "PostTutor"
          link = post_tutor_path(obj)
          img_link = link_to image_post_thumb("post_tutors", obj.post), link, :target => "_blank"
          image = '<div class="assImg"><div>' + img_link + '</div></div>'
          title = obj.post.title
          sub_content = truncate_html(obj.post.description, :length => 100, :omission => '...')
          when "PostBook"
          link = post_book_path(obj)
          img_link = link_to image_post_thumb("post_books", obj.post), link, :target => "_blank"
          image = '<div class="assImg"><div>' + img_link + '</div></div>'
          title = obj.post.title
          sub_content = truncate_html(obj.post.description, :length => 100, :omission => '...')
          when "PostJob"
          link = post_job_path(obj)
          img_link = link_to image_post_thumb("post_jobs", obj.post), link, :target => "_blank"
          image = '<div class="assImg"><div>' + img_link + '</div></div>'
          title = obj.post.title
          sub_content = truncate_html(obj.post.description, :length => 100, :omission => '...')
          when "PostFood"
          link = post_food_path(obj)
          img_link = link_to image_post_thumb("post_foods", obj.post), link, :target => "_blank"
          image = '<div class="assImg"><div>' + img_link + '</div></div>'
          title = obj.post.title
          sub_content = truncate_html(obj.post.description, :length => 100, :omission => '...')
          when "PostParty"
          link = post_party_path(obj)
          img_link = link_to image_post_thumb("post_parties", obj.post), link, :target => "_blank"
          image = '<div class="assImg"><div>' + img_link + '</div></div>'
          title = obj.post.title
          sub_content = truncate_html(obj.post.description, :length => 100, :omission => '...')
          when "PostMyx"
          link = post_myx_path(obj)
          img_link = link_to image_post_thumb("post_myxes", obj.post), link, :target => "_blank"
          image = '<div class="assImg"><div>' + img_link + '</div></div>'
          title = obj.post.title
          sub_content = truncate_html(obj.post.description, :length => 100, :omission => '...')
          when "PostAwareness"
          link = post_awareness_path(obj)
          img_link = link_to image_post_thumb("post_awarenesses", obj.post), link, :target => "_blank"
          image = '<div class="assImg"><div>' + img_link + '</div></div>'
          title = obj.post.title
          sub_content = truncate_html(obj.post.description, :length => 100, :omission => '...')
          when "PostHousing"
          link = post_housing_path(obj)
          img_link = link_to image_post_thumb("post_housings", obj.post), link, :target => "_blank"
          image = '<div class="assImg"><div>' + img_link + '</div></div>'
          title = obj.post.title
          sub_content = truncate_html(obj.post.description, :length => 100, :omission => '...')
          when "PostTeamup"
          link = post_teamup_path(obj)
          img_link = link_to image_post_thumb("post_teamups", obj.post), link, :target => "_blank"
          image = '<div class="assImg"><div>' + img_link + '</div></div>'
          title = obj.post.title
          sub_content = truncate_html(obj.post.description, :length => 100, :omission => '...')
          when "PostExamSchedule"
          link = post_exam_schedule_path(obj)
          img_link = link_to image_post_thumb("post_exam_schedules", obj.post), link, :target => "_blank"
          image = '<div class="assImg"><div>' + img_link + '</div></div>'
          title = obj.post.title
        end
      end
    end
    
    render :partial => "user_walls/wall_attach", :locals => {:wall_id => wall.id, :image => image, :title => title, :link => link, :sub_content => sub_content}
  end
  
  def get_image_wall(wall_id, link)
    "<div class='AfterImg' id='wall_attach_#{wall_id}'><div class='imgDiv'>#{link}</div></div>"
  end
  
  def get_object_by_class_name_and_id(class_name, id)
    begin
      eval(class_name).find(id)
    rescue
      nil
    end
  end
  
  def show_refer_to_experts(post)
    if !logged_in?
      link_to_require_login(raw("<span>Refer to experts</span>"))
    else
      link_to(raw("<span>Refer to experts</span>"), "#{prefer_post_qas_path}?height=300&width=490&post_id="+post.id.to_s, :class => "thickbox", :title => "Rerfer to experts")
    end
  end
  
  def show_report_abuse(post)
    if !logged_in?
      link_to_require_login(raw("<span>Report Abuse</span>"))
    else
      link_to(raw("<span>Report Abuse</span>"), "#{report_abuse_posts_path}?reported_id=#{post.id}&reported_type=#{post.class.name}&height=320&width=490", :class => "thickbox", :title => "Report Abuse")
    end
  end
  
  def show_report_abuse_video(post)
    if !logged_in?
      link_to_require_login(raw("<span>Report Abuse</span>"))
    else
      link_to(raw("<span>Report Abuse</span>"), "#{report_abuse_video_posts_path}?reported_id=#{post.id}&reported_type=#{post.class.name}&height=320&width=490", :class => "thickbox", :title => "Report Abuse")
    end
  end
  
  def show_report_abuse_comment_video(comnt)
    if !logged_in?
      link_to_require_login(raw("Report Abuse"))
    else
      link_to(raw("Report Abuse"), "#{report_abuse_video_posts_path}?reported_id=#{comnt.id}&reported_type=Comment&height=320&width=490", :class => "thickbox", :title => "Report Abuse")
    end
  end
  
  def show_report_abuse_comment(comnt)
    if !logged_in?
      link_to_require_login(raw("Report Abuse"))
    else
      link_to(raw("Report Abuse"), "#{report_abuse_posts_path}?reported_id=#{comnt.id}&reported_type=Comment&height=320&width=490", :class => "thickbox", :title => "Report Abuse")
    end
  end
  
  def show_school_address(school)
    school.name + ", " + school.city.name + ", " + school.city.state.name + ", " + school.city.state.country.name
  end
  
  def gmap_key
    case Rails.env
      when 'production'
      key = GMAP_KEY_SITE
      when 'development'
      key = GMAP_KEY_LOCAL
      when 'staging'
      key = GMAP_KEY_STAGING
    end
    return key
  end
  
  def display_flash_messages_with_raw
    raw(display_flash_messages)
  end
  
  def textilize(text)
    Textilizer.new(text).to_html.html_safe unless text.blank?
  end
  
  def check_private_permission(user, type)
    check = false
    if user == current_user
      check = true
    else
      ps = PrivateSetting.where(:user_id => user.id, :type_setting => type).first
      if ps
        share_to = ps.share_to
        case share_to
          when 1 # Friend from school
          if current_user
            fg = FriendGroup.where(:label => "friends_from_school").first
            fng = FriendInGroup.where(:user_id => user.id, :user_id_friend => current_user.id, :friend_group_id => fg.id).first
            check = true if fng
          end
          when 2 # Friend of friends
          if current_user
            fof = user.friend_of_friends
            check = fof.include?(current_user)
          end
          when 3 # My Family
          if current_user
            fg = FriendGroup.where(:label => "family_members").first
            fng = FriendInGroup.where(:user_id => user.id, :user_id_friend => current_user.id, :friend_group_id => fg.id).first
            check = true if fng
          end
          when 4 # My friends
          if current_user
            check = true if user.user_friends.include?(current_user)
          end
          when 5 # Friends from work
          if current_user
            fg = FriendGroup.where(:label => "friends_from_work").first
            fng = FriendInGroup.where(:user_id => user.id, :user_id_friend => current_user.id, :friend_group_id => fg.id).first
            check = true if fng
          end
          when 6 # Every one
          check = true
        end
      end
    end
    return check
  end
  
  def users_browser
    user_agent =  request.env['HTTP_USER_AGENT'].downcase
    @users_browser ||= begin
      if user_agent.index('msie') && !user_agent.index('opera') && !user_agent.index('webtv')
        'ie'+user_agent[user_agent.index('msie')+5].chr
      elsif user_agent.index('gecko/')
        'gecko'
      elsif user_agent.index('opera')
        'opera'
      elsif user_agent.index('konqueror')
        'konqueror'
      elsif user_agent.index('ipod')
        'ipod'
      elsif user_agent.index('ipad')
        'ipad'
      elsif user_agent.index('iphone')
        'iphone'
      elsif user_agent.index('chrome/')
        'chrome'
      elsif user_agent.index('applewebkit/')
        'safari'
      elsif user_agent.index('googlebot/')
        'googlebot'
      elsif user_agent.index('msnbot')
        'msnbot'
      elsif user_agent.index('yahoo! slurp')
        'yahoobot'
        #Everything thinks it's mozilla, so this goes last
      elsif user_agent.index('mozilla/')
        'gecko'
      else
        'unknown'
      end
    end
    
    return @users_browser
  end
  
  def get_among_for_tag(num, num_total)
    num_percent = (num / num_total)*100
    case num_percent
      when  0..20  then 1
      when 21..40  then 2
      when 41..60  then 3
      when 61..80  then 4
      when 81..100 then 5
    end
  end
  
  def get_video_id(link)
    video_regexp = [/^(?:https?:\/\/)?(?:www\.)?youtube\.com(?:\/v\/|\/watch\?v=)([A-Za-z0-9_-]{11})/, 
    /^(?:https?:\/\/)?(?:www\.)?youtu\.be\/([A-Za-z0-9_-]{11})/, 
    /^(?:https?:\/\/)?(?:www\.)?youtube\.com\/user\/[^\/]+\/?#(?:[^\/]+\/){1,4}([A-Za-z0-9_-]{11})/]
    video_regexp.each { |m| return link.match(m)[1] unless link.match(m).nil? }
  end
  
  def get_video_path(link)
    begin
      Domainatrix.parse(link)
      return link
    rescue
      return request.protocol + request.host_with_port + link
    end
  end
  
  def show_ajax_loader(str_id, str_style)
    content_tag(:span, image_tag("/images/ajax-loader-a.gif", :alt => '', :style => str_style, :id => str_id))
  end  
  
  private
  
  def link_to_require_login(str)
    call_back = root_url[0...-1] + request.request_uri
    link_login = "https://login.afterclassroom.com/login?service=#{call_back}"
    str_require_login = "This function is available only to registered users."
    link_to(str, link_login, :class => "vtip", :title => str_require_login)
  end
  
end
