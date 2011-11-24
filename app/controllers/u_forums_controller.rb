class UForumsController < ApplicationController

  layout 'student_lounge'

  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  before_filter :get_variables  

  def show
    @ufo = Ufo.find(params[:id])

    if current_user != @ufo_author
      check = false
      #case 1: when author share the topic with current_user's groups
      str_share = @ufo.ufo_custom.share_to_index
      arr_p = [] 
      OPTIONS_SETTING.select {|p| arr_p << p if p[1] == str_share.to_i} 
      share_to = get_share(arr_p[0][1])
      if share_to != nil
        if share_to.include?(current_user)
          check = true
        end
      end
      #case 2: author does not share with current_user's groups, but current_user is a member of topic
      if !check
        if @ufo.ufo_members.where(:user_id => current_user.id).size > 0 
          check = true
        end
      end

      if !check
        redirect_to warning_user_path(@ufo_author)
      end
    end

    @ufo_cmts = @ufo.ufo_cmts.paginate(:page => params[:page], :per_page => 10)

    @ufo_cmt = UfoCmt.new()
    @members = @ufo.ufo_members ? @ufo.ufo_members.paginate(:page => params[:page], :per_page => 16) : nil

    @cur_page = "1"
    session[:list_remove_usrs] = []#this array stores the list of member to be removed
    @prechecked = []

    session[:list_selected_show] = []#this array stores the list of member to be added to topic

    #BEGIN load the user-friend based on user-topic-setting
    str_share = @ufo.ufo_custom.share_to_index
    arr_p = [] 
    OPTIONS_SETTING.select {|p| arr_p << p if p[1] == str_share.to_i} 
    share_to = get_share(arr_p[0][1])
    @share_to = share_to ? share_to.paginate(:page => params[:page], :per_page => 2) : nil
    #END load the user-friend based on user-topic-setting
  end

  def new
    @ufo = Ufo.new()

    session[:list_selected_usrs] = []

    share_to = nil
    if current_user.ufo_default != nil
      share_to = get_share(current_user.ufo_default.share_to_index.to_i)
    else
      share_to = get_share(0)
    end
    @share_to = share_to ? share_to.paginate(:page => params[:page], :per_page => 2) : nil
    @cur_page = share_to ? "1" : 0
  end

  def save
    @ufo = Ufo.new(params[:ufo])
    @ufo.user = current_user
    if @ufo.save
      flash[:notice] = "Your topic was successfully submitted."

      custom_setting = UfoCustom.find_or_create_by_ufo_id(@ufo.id)
      custom_setting.share_to_index = params[:ufo_setting]
      custom_setting.post_lounge = params[:lounge_setting]
      custom_setting.save

      session[:list_selected_usrs].each do |usr_id|
        member = UfoMember.new
        member.user_id = usr_id
        member.ufo_id = @ufo.id
        member.save
      end

      @ufo = Ufo.new()
      session[:list_selected_usrs] = [] #reset the session that store the selected users

      redirect_to user_u_forums_path(current_user)
    else
      flash[:notice] = "Failed to create new topic."
      render :action => "new"
    end

  end

  def dft_stgs
    render :layout => false
  end


  def save_setting
    default_setting = UfoDefault.find_or_create_by_user_id(current_user.id)
    default_setting.share_to_index = params[:shareto]
    default_setting.post_lounge = params[:postlounge]
    default_setting.save

    render :layout => false 
  end

  def save_custom
    custom_setting = UfoCustom.find_or_create_by_ufo_id(params[:id])
    custom_setting.share_to_index = params[:shareto]
    custom_setting.post_lounge = params[:postlounge]
    custom_setting.save

    #BEGIN load the proper user-friends based on setting
    arr_p = [] 
    OPTIONS_SETTING.select {|p| arr_p << p if p[1] == params[:shareto].to_i} 
    share_to = get_share(arr_p[0][1])
    @share_to = share_to ? share_to.paginate(:page => params[:page], :per_page => 2) : nil
    #END load the proper user-friends based on setting
    
    #init the session to store the list of selected user to add to friend list
    session[:list_selected_show] = []

    render :layout => false 
  end

  def save_custom_b
    @ufo = Ufo.find(params[:id])
    custom_setting = UfoCustom.find_or_create_by_ufo_id(params[:id])
    custom_setting.share_to_index = params[:shareto]
    custom_setting.post_lounge = params[:postlounge]
    custom_setting.save

    render :layout => false 
  end

  def index
    @ufo = nil
    if current_user == @ufo_author
      @ufos = @ufo_author.ufos.order("created_at DESC").paginate(:page => params[:page], :per_page => 2)
    else

      @ufos = @ufo_author.ufos

      tmparr = []

      @ufos.each do |ufo|
        check = false
        #case 1: when author share the topic with current_user's groups
        str_share = ufo.ufo_custom.share_to_index
        arr_p = [] 
        OPTIONS_SETTING.select {|p| arr_p << p if p[1] == str_share.to_i} 
        share_to = get_share(arr_p[0][1])
        if share_to != nil
          if share_to.include?(current_user)
            tmparr << ufo
            check = true
          end
        end
        #case 2: author does not share with current_user's groups, but current_user is a member of topic
        if !check
          if ufo.ufo_members.where(:user_id => current_user.id).size > 0 
            tmparr << ufo
          end
        end
      end

      @ufos = tmparr.paginate(:page => params[:page], :per_page => 2)

    end
  end

  def save_cmt
    objufo = Ufo.find(params[:ufo_id])

    ufo_cmt = UfoCmt.new(params[:ufo_cmt])
    ufo_cmt.user = current_user
    ufo_cmt.ufo = objufo
    ufo_cmt.save

    #render :layout => false 
    redirect_to user_u_forum_path(objufo.user, objufo)

  end

  def post_lounge
    objufo = Ufo.find(params[:id])
    post_wall(objufo)

    custom_setting = UfoCustom.find_or_create_by_ufo_id(params[:id])
    custom_setting.post_lounge = params[:postlounge]
    custom_setting.save
  end

  def post_lounge_b
    @objufo = Ufo.find(params[:id])
    post_wall(@objufo)

    custom_setting = UfoCustom.find_or_create_by_ufo_id(params[:id])
    custom_setting.post_lounge = params[:postlounge]
    custom_setting.save
  end

  def item_setting
    @objufo = Ufo.find(params[:id])
    render :layout => false
  end

  def rate
    rating = params[:rating]
    @ufo = Ufo.find(params[:post_id])
    @ufo.rate rating.to_i, current_user

    # Update rating status
    score_good = @ufo.score_good
    score_bad = @ufo.score_bad
    
    if score_good == score_bad
      status = "Require Rating"
    else
      sort_rating_status = {"Good" => score_good, "Bad" => score_bad}
      arr_rating_status = sort_rating_status.sort { |a, b| a[1] <=> b[1] }
      status = arr_rating_status.last.first
    end
    
    @ufo.rating_status = status
    @ufo.save


    @text = "<div class='qashdU'><a href='javascript:;' class='vtip' title='#{configatron.str_rated}'>#{@ufo.total_good}</a></div>"
    @text << "<div class='qashdD'><a href='javascript:;' class='vtip' title='#{configatron.str_rated}'>#{@ufo.total_bad}</a></div>"

  end

  def friend_pad
    render :layout => false
  end
  def friend_pad_show
    @ufo_id = params[:ufo_id]
    render :layout => false
  end

  def find_people
    query = params[:search_name]
    @users = User.search do
      if params[:search_name].present?
        keywords(query) do
          highlight :name
        end
      end
      order_by :created_at, :desc
      paginate :page => params[:page], :per_page => 5
    end
    render :layout => false
  end

  def find_people_show
    puts "val of id = #{params[:ufo_id]}"
    objufo = Ufo.find(params[:ufo_id])

    query = params[:search_name]
    objusers = User.search do
      if params[:search_name].present?
        keywords(query) do
          highlight :name
        end
      end
      order_by :created_at, :desc
      paginate :page => params[:page], :per_page => 5
    end
    @users = objusers.results.select  { |usr| !objufo.ufo_members.map(&:user_id).include?(usr.id) }
    render :layout => false
  end


  def select_share
    @share = params[:share]

    arr_p = [] 
    OPTIONS_SETTING.select {|p| arr_p << p if p[1] == params[:share].to_i} 

    share_to = get_share(arr_p[0][1])
    @share_to = share_to ? share_to.paginate(:page => params[:page], :per_page => 2) : nil

    #reset the selected users
    session[:list_selected_usrs] = []

    render :layout => false
  end

  def page_share

    share_to = get_share(params[:share].to_i)

    @share_to = share_to ? share_to.paginate(:page => params[:page], :per_page => 2) : nil
    @cur_page = params[:page]
    render :layout => false
  end

  def add_usr
    @usr = User.find(params[:usr_id])
    session[:list_selected_usrs] << @usr.id

    render :layout => false
  end

  def remove_usr
    @usr = User.find(params[:usr_id])
    arr_p = []
    session[:list_selected_usrs].select { |p| arr_p << p if p != @usr.id  }
 
    session[:list_selected_usrs] = arr_p

    render :layout => false
  end

  def remove_member
    #BEGIN: synchronize the list of selected user before remove
    arr_precheck = nil
    if params[:precheck_list].length > 0
      arr_precheck =  params[:precheck_list].split(',')
    end

    remove_check = nil
    if arr_precheck != nil && params[:user_list] != nil
      remove_check = arr_precheck.select { |id| !params[:user_list].include?(id) }
    end
    add_check = nil
    if arr_precheck != nil && params[:user_list] != nil && params[:user_list] != ""
      add_check = params[:user_list].select { |id| !arr_precheck.include?(id) }
    elsif arr_precheck == nil
      add_check = params[:user_list]
    end

    if session[:list_remove_usrs].size == 0 && add_check != nil
      session[:list_remove_usrs] = add_check
    elsif session[:list_remove_usrs].size > 0
      if add_check != nil
        add_check.each do |id|
          session[:list_remove_usrs] << id
        end
      end
      if remove_check != nil
        tmp = []
        tmp = session[:list_remove_usrs].select { |id| !remove_check.include?(id) }
        session[:list_remove_usrs] = tmp
      end
    end
    #END: synchronize the list of selected user before remove

    @ufo = Ufo.find(params[:ufo_id])
    session[:list_remove_usrs].each do |id|
      member = @ufo.ufo_members.where(:user_id => id).first
      member.destroy
    end 
    redirect_to user_u_forum_path(current_user,@ufo)
  end

  def page_member
    #BEGIN analyze selected user to be removed
    remove_check = nil
    if params[:listcheck] != nil && params[:precheck] != nil && params[:precheck] != ""
      remove_check = params[:precheck].select { |id| !params[:listcheck].include?(id) }
    end

    add_check = nil
    if params[:listcheck] != nil && params[:precheck] != nil && params[:listcheck] != ""
      add_check = params[:listcheck].select { |id| !params[:precheck].include?(id) }
    end

    if session[:list_remove_usrs].size == 0 && add_check != nil
      session[:list_remove_usrs] = add_check
    elsif session[:list_remove_usrs].size > 0
      if add_check != nil
        add_check.each do |id|
          session[:list_remove_usrs] << id
        end
      end
      if remove_check != nil
        tmp = []
        tmp = session[:list_remove_usrs].select { |id| !remove_check.include?(id) }
        session[:list_remove_usrs] = tmp
      end
    end
    #END analyze selected user to be removed

    @cur_page = params[:page]
    @ufo = Ufo.find(params[:ufo_id])
    @members = @ufo.ufo_members ? @ufo.ufo_members.paginate(:page => params[:page], :per_page => 16) : nil
    

    @enableCheckbox = params[:enableCheckbox] == "true" ? true : false

    render :layout => false
  end

  def add_usr_show
    @usr = User.find(params[:usr_id])
    session[:list_selected_show] << @usr.id

    render :layout => false
  end

  def page_share_show
    @ufo = Ufo.find(params[:ufo_id])

    share_to = get_share(params[:share].to_i)

    @share_to = share_to ? share_to.paginate(:page => params[:page], :per_page => 2) : nil
    @cur_page = params[:page]

    render :layout => false
  end

  def remove_usr_show
    @usr = User.find(params[:usr_id])
    arr_p = []
    session[:list_selected_show].select { |p| arr_p << p if p != @usr.id  }
    session[:list_selected_show] = arr_p
    render :layout => false
  end

  def add_more_member
    objufo = Ufo.find(params[:ufo_id])
    session[:list_selected_show].each do |usr_id|
      member = UfoMember.new
      member.user_id = usr_id
      member.ufo_id = objufo.id
      member.save
    end

    session[:list_selected_show] = []

    redirect_to user_u_forum_path(objufo.user, objufo)
  end

  def unsubscribe
    objufo = Ufo.find(params[:ufo_id])
    member = objufo.ufo_members.where(:user_id => current_user.id).first
    member.destroy

    render :layout => false
  end

  private
  def get_share(share_value)
    groupType = ""
    share_to = nil  
    case share_value
    when 0 # Private
      groupType = -1 #for testing purpose only
    when 1 # Friend from school
      groupType="friends_from_school"
    when 2 # Friend of friends
    when 3 # My Family
    when 4 # My friends
    when 5 # Friends from work
      groupType="friends_from_work"
    when 6 # Everyone
    end
    fg = FriendGroup.where(:label => groupType).first
    if fg != nil
      share_to = User.find(:all, :joins => "INNER JOIN friend_in_groups ON friend_in_groups.user_id_friend = users.id", :conditions => ["friend_in_groups.user_id=? and friend_group_id=?", @ufo_author.id, fg.id ] )
    end
    share_to
  end

  def get_variables
    @ufo_author = User.where(:login => params[:user_id]).first
  end

end
