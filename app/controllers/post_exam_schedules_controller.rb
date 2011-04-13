class PostExamSchedulesController < ApplicationController
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter, :except => [:index, :show, :search]
  before_filter :cas_user
  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search]
  #before_filter :login_required, :except => [:index, :show, :search]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search]
  after_filter :store_go_back_url, :only => [:index, :show, :search]
  
  # GET /post_exam_schedules
  # GET /post_exam_schedules.xml
  def index
    @posts = PostExamSchedule.paginated_post_conditions_with_option(params, @school, @type_schedule)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  # GET /post_exam_schedules/1
  # GET /post_exam_schedules/1.xml
  def show
    @post_exam_schedule = PostExamSchedule.find(params[:id])
    @post = @post_exam_schedule.post
    update_view_count(@post)
    posts_as = PostExamSchedule.with_school(@school)
    as_next = posts_as.next(@post_exam_schedule.id).first
    as_prev = posts_as.previous(@post_exam_schedule.id).first
    @next = as_next if as_next
    @prev = as_prev if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_exam_schedule }
    end
  end
  
  def search
    @query = params[:search][:query] if params[:search]
    if params[:search]
      @posts = Post.paginated_post_conditions_with_search(params, @school, @type)
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def tag
    @tag_name = params[:tag_name]
    @posts = PostExamSchedule.paginated_post_conditions_with_tag(params, @school, @tag_name)
  end
  
  def rate
    rating = params[:rating]
    post = Post.find(params[:post_id])
    post_tt = post.post_tutor
    post_tt.rate rating.to_i, current_user
    # Update rating status
    score_good = post_tt.score_good
    score_bad = post_tt.score_bad
    
    if score_good > score_bad
      status = "Good"
    elsif score_good == score_bad
      status = "Require Rating"
    else
      status = "Bad"
    end
    
    post_tt.rating_status = status
    
    post_tt.save
    
    render :text => %Q'
      <div class="qashdU">
        <a href="javascript:;" class="vtip" title="#{configatron.str_rated}">#{post_tt.total_good}</a>
      </div>
      <div class="qashdD">
        <a href="javascript:;" class="vtip" title="#{configatron.str_rated}">#{post_tt.total_bad}</a>
      </div>
      <script>
        vtip();
      </script>'
  end

  # GET /post_exam_schedules/new
  # GET /post_exam_schedules/new.xml
  def new
    @post_exam_schedule = PostExamSchedule.new
    @post = Post.new
    @post_exam_schedule.post = @post
    @post_exam_schedule.type_name = @type_schedule

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_exam_schedule }
    end
  end

  # GET /post_exam_schedules/1/edit
  def edit
    @post_exam_schedule = PostExam.find(params[:id])
    @post = @post_exam_schedule.post
    @tag_list = @post_exam_schedule.tags_from(@post.school).join(", ")
  end

  # POST /post_exam_schedules
  # POST /post_exam_schedules.xml
  def create
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.school_id = @school
    @post.post_category_id = @type
    @post.type_name = @class_name
    @post.save
    @post_exam_schedule = PostExamSchedule.new(params[:post_exam_schedule])
    @post.school.tag(@post_exam_schedule, :with => params[:tag], :on => :tags)
    @post.school.owned_taggings
    @post.school.owned_tags
    @post_exam_schedule.post = @post
    if simple_captcha_valid?
      if @post_exam_schedule.save
        notice "Your post was successfully created."
        redirect_to post_exam_schedules_path + "?type=#{@post_exam_schedule.type_name}"
      else
        error "Failed to create a new post."
        render :action => "new"
      end
    else
      warning "Captcha not match."
      render :action => "new"
    end
  end

  # PUT /post_exam_schedules/1
  # PUT /post_exam_schedules/1.xml
  def update
    @post_exam_schedule = PostExam.find(params[:id])
    @post = @post_exam_schedule.post
    
    if (@post_exam_schedule.update_attributes(params[:post_exam_schedule]) && @post.update_attributes(params[:post]))
      @post.school.tag(@post_exam_schedule, :with => params[:tag], :on => :tags)
      redirect_to post_exam_url(@post_exam_schedule)
    end
  end

  # DELETE /post_exam_schedules/1
  # DELETE /post_exam_schedules/1.xml
  def destroy
    @post_exam_schedule = PostExamSchedule.find(params[:id])
    @post_exam_schedule.destroy

    respond_to do |format|
      format.html { redirect_to(post_exam_schedules_url) }
      format.xml  { head :ok }
    end
  end

  private

  def get_variables
    @school = session[:your_school]
    @type_schedule = params[:type]
    @type_schedule ||= "exam_schedule"
    @tags = PostExamSchedule.tag_counts_on(:tags)
    @new_post_path = "#{new_post_exam_schedule_path}?type=#{@type_schedule}"
    @class_name = "PostExamSchedule"
    @type = PostCategory.find_by_class_name(@class_name).id
    @query = params[:search][:query] if params[:search]
  end

  def require_current_user
    post_exam_schedule = PostExamSchedule.find(params[:id])
    post = post_exam_schedule.post
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
