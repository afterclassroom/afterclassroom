class PostExamSchedulesController < ApplicationController
  include Viewable

  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search]
  before_filter :login_required, :except => [:index, :show, :search]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search]
  after_filter :store_go_back_url, :only => [:index, :show, :search]
  
  # GET /post_exam_schedules
  # GET /post_exam_schedules.xml
  def index
    @posts = PostExamSchedule.paginated_post_conditions_with_type(params, @school, @type_schedule)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /post_exam_schedules/1
  # GET /post_exam_schedules/1.xml
  def show
    @post_exam_schedule = PostExamSchedule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_exam_schedule }
    end
  end

  # GET /post_exam_schedules/new
  # GET /post_exam_schedules/new.xml
  def new
    @post_exam_schedule = PostExamSchedule.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_exam_schedule }
    end
  end

  # GET /post_exam_schedules/1/edit
  def edit
    @post_exam_schedule = PostExamSchedule.find(params[:id])
  end

  # POST /post_exam_schedules
  # POST /post_exam_schedules.xml
  def create
    @post_exam_schedule = PostExamSchedule.new(params[:post_exam_schedule])

    respond_to do |format|
      if @post_exam_schedule.save
        flash[:notice] = 'PostExamSchedule was successfully created.'
        format.html { redirect_to(@post_exam_schedule) }
        format.xml  { render :xml => @post_exam_schedule, :status => :created, :location => @post_exam_schedule }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post_exam_schedule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /post_exam_schedules/1
  # PUT /post_exam_schedules/1.xml
  def update
    @post_exam_schedule = PostExamSchedule.find(params[:id])

    respond_to do |format|
      if @post_exam_schedule.update_attributes(params[:post_exam_schedule])
        flash[:notice] = 'PostExamSchedule was successfully updated.'
        format.html { redirect_to(@post_exam_schedule) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post_exam_schedule.errors, :status => :unprocessable_entity }
      end
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
    @type_schedule = params[:type]
    @type_schedule ||= "exam_schedule"
    @tags = PostAwareness.tag_counts
    @new_post_path = "#{new_post_exam_schedule_path}?type=#{@type_schedule}"
    @class_name = "PostAwareness"
    @type = PostCategory.find_by_class_name(@class_name).id
    @school = session[:your_school]
    @query = params[:search][:query] if params[:search]
  end

  def require_current_user
    @post = PostExamSchedule.find(params[:id])
    @user ||= @post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
