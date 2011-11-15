class UForumsController < ApplicationController

  layout 'student_lounge'

  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  

  def show
    @ufo = Ufo.find(params[:id])
    @ufo_cmts = @ufo.ufo_cmts.paginate(:page => params[:page], :per_page => 10)

    @ufo_cmt = UfoCmt.new()
  end

  def new
    @ufo = Ufo.new()
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

      @ufo = Ufo.new()
      #render :action => "new"
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
    @ufos = current_user.ufos.paginate(:page => params[:page], :per_page => 2)
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

  def select_share
    @share = params[:share]

    arr_p = [] 
    OPTIONS_SETTING.select {|p| arr_p << p if p[1] == params[:share].to_i} 


    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "
    puts "val == #{arr_p[0][0]} "


    render :layout => false
  end


end
