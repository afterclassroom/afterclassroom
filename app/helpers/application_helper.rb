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

  def show_favorite(post)
    if !logged_in?
      "Favorite (#{post.favorites.size})"
    elsif current_user.has_favorite?(post)
      "Favorite (#{post.favorites.size})"
    else
      link_to_remote "Favorite (#{post.favorites.size})", { :update => "post_favorite_#{post.id}", :url => {:controller => "posts", :action => "add_to_favorite", :post_id => post.id } }
    end
  end

  def show_favorite_in_detail(post)
    id = "#favorite_action"
    str_login = "You must be #{link_to "logged in", login_url} to favorite this post."
    str_favorited = "It`s already in your favourite list."
    
    if !logged_in?
      link_to("<span id='favorite_action'>Favorite (#{post.favorites.size})</span>", "javascript:;") + "<script>#{tool_tip(id, str_login)}</script>"
    elsif current_user.has_favorite?(post)
      link_to("<span id='favorite_action'>Favorite (#{post.favorites.size})</span>", "javascript:;") + "<script>#{tool_tip(id, str_favorited)}</script>"
    else
      link_to_remote "<span>Favorite (#{post.favorites.size})</span>", { :update => "post_favorite_#{post.id}", :url => {:controller => "posts", :action => "add_to_favorite_in_detail", :post_id => post.id } }
    end
  end

  def show_email(post)
    id = "#email_action"
    str_login = "You must be #{link_to "logged in", login_url} to send an email."
    if !logged_in?
      link_to("<span id='email_action'>Email</span>", "javascript:;") + "<script>#{tool_tip(id, str_login)}</script>"
    else
      link_to("<span>Email</span>", "#{show_email_user_messages_path(post.user)}?user_id=#{post.user.id}&height=200&width=280", :class => "thickbox", :title => "Send to #{post.user.full_name}")
    end
  end

  def show_go_back
    link_to "<span>Go back</span>", session[:go_back_url]
  end

  def show_submit_rating(post_id, path)
    id = "#submit_rating"
    str_login = "You must be #{link_to "logged in", login_url} to poll."
    if !logged_in?
      link_to("<span id='submit_rating'>Submit</span>", "javascript:;") + "<script>#{tool_tip(id, str_login)}</script>"
    else
      link_to("<span>Submit</span>", "javascript:;", :onclick => "requireRating('#{post_id}', '#{path}');")
    end
  end

  private

  def tool_tip(id, content)
    "$('#{id}').bt('#{content}', {trigger: 'click', positions: 'top'});"
  end
end
