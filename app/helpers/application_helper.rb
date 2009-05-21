# © Copyright 2009 AfterClassroom.com — All Rights Reserved
module ApplicationHelper
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
    html_options = {}

    if all_options.is_a?(Array)
      all_options.each do |o|
        if url_for(o.merge({:only_path => false})) == current_url
          html_options = {:class => "current"}
          break
        end
      end  
    end

    link_to(name, url, html_options)
  end

  # Return true if the currently logged in user is an admin
  def admin?
    logged_in? && current_user.has_role?(:admin)
  end
  
  # Write a secure email adress
  def secure_mail_to(email)
    mail_to email, nil, :encode => 'javascript'
  end

  def select_your_school_for_edit_information(model_name, partial_path, user, options={})
    if user.school
      school = user.school
      city = user.school.city
    else
      school = School.find(:first)
      city = school.city
    end
    @countries = Country.has_cities
    render :partial => partial_path, :locals => {:countries => @countries, :city => city, :school => school, :model_name => model_name, :options => options}
  end

  def select_your_school_for_edit_post(model_name, partial_path, school, department, options={})
    @countries = Country.has_cities
    render :partial => partial_path, :locals => {:countries => @countries, :city => school.city, :school => school, :department => department, :model_name => model_name, :options => options}
  end
  
  def select_your_school(model_name, partial_path, options={})
    @countries = Country.has_cities
    if session[:your_school]
      @your_school = School.find(session[:your_school])
    else
      if current_user && current_user.school
        @your_school = current_user.school
        session[:your_school] = @your_school
      end
    end
    if @your_school
      render :partial => partial_path, :locals => {:countries => @countries, :city => @your_school.city, :school => @your_school, :department => nil, :model_name => model_name, :options => options}
    else
      # location is a GeoLoc instance
      location = session[:geo_location]
      if location
        country_code = location.country_code
        name = location.city
        @city = City.search_by_country_code({:country_code => country_code})
        if !@city
          @city = City.first_city_has_schools.first
        end
      else
        @city = City.first_city_has_schools.first
      end
      render :partial => partial_path, :locals => {:countries => @countries, :city => @city, :school => nil, :department => nil, :model_name => model_name, :options => options}
    end
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

  def your_favorite_today
    @favorites = current_user.favorites.find(:all, :conditions => ["date(created_at) = ?", Date.today.to_s], :order => "created_at DESC", :limit => 10) if current_user
    render :partial => "posts/your_favorite_today", :locals => {:favorites => @favorites}
  end

  def show_post_with_title(post)
    post_category_name = post.post_category.name
    case post_category_name
    when "Education"
      link_to post.title, post.post_education
    when "Tutors"
      link_to post.title, post.post_tutor
    when "Books"
      link_to post.title, post.post_book
    when "Jobs"
      link_to post.title, post.post_job
    when "Party"
      link_to post.title, post.post_party
    when "Student Awareness"
      link_to post.title, post.post_awareness
    when "Housing"
      link_to post.title, post.post_housing
    when "Team Up"
      link_to post.title, post.post_teamup
    else
      link_to post.title, post
    end
  end

  def getGender(sex)
    if sex
      sex == true ? "Male" : "Female"
    else
      "N/A"
    end
  end

  def cell(label, value)
    "<tr>
  		<td class='label' nowrap='nowrap'>#{label}</td>
  		<td class='value'>#{value}</td>
  	</tr>"
  end

  def cell_separator
    "<tr>
  		<td colspan='2' class='separator'></td>
  	</tr>"
  end
end
