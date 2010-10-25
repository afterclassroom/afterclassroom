# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostJobsController < ApplicationController
  include Viewable

  skip_before_filter :verify_authenticity_token

  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search, :tag, :good_companies, :bad_bosses, :my_job_list, :add_job, :employment_infor, :show_job_infor]
  before_filter :login_required, :except => [:index, :show, :search, :tag, :good_companies, :bad_bosses, :employment_infor, :show_job_infor]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search, :tag, :good_companies, :bad_bosses]
  after_filter :store_go_back_url, :only => [:index, :search, :tag, :good_companies, :bad_bosses]
  # GET /post_jobs
  # GET /post_jobs.xml
  def index
    if params[:more_like_this_id]
      id = params[:more_like_this_id]
      post = Post.find_by_id(id)
      @posts = Post.paginated_post_more_like_this(params, post)
    else
      @job_type_id = params[:job_type_id]
      @job_type_id ||= JobType.find(:first).id
      @posts = PostJob.paginated_post_conditions_with_option(params, @school, @job_type_id)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
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
    tag_id = params[:tag_id]
    @tag = Tag.find(tag_id)
    @posts = PostJob.paginated_post_conditions_with_tag(params, @school, @tag.name)
  end

  def good_companies
    @posts = PostJob.paginated_post_conditions_with_good_companies(params, @school)
  end

  def bad_bosses
    @posts = PostJob.paginated_post_conditions_with_bad_bosses(params, @school)
  end

  def rate
    rating = params[:rating]
    post = Post.find(params[:post_id])
    post_j = post.post_job
    post_j.rate rating.to_i, current_user
    # Update rating status
    score_good = post_j.score_good
    score_bad = post_j.score_bad

    if score_good > score_bad
      status = "Good"
    elsif score_good == score_bad
      status = "Require Rating"
    else
      status = "Bad"
    end

    post_j.rating_status = status

    post_j.save

    render :text => %Q'
      <div class="qashdU">
        <a href="javascript:;" class="vtip" title="#{Setting.get(:str_rated)}">#{post_j.total_good}</a>
      </div>
      <div class="qashdD">
        <a href="javascript:;" class="vtip" title="#{Setting.get(:str_rated)}">#{post_j.total_bad}</a>
      </div>
      <script>
        vtip();
      </script>'
  end

  def require_rate
    rating = params[:rating]
    post = Post.find(params[:post_id])
    post_j = post.post_job
    if !PostJob.find_rated_by(current_user).include?(post_j)
      post_j.rate rating.to_i, current_user
      # Update rating status
      score_good = post_j.score_good
      score_bad = post_j.score_bad

      if score_good > score_bad
        status = "Good"
      elsif score_good == score_bad
        status = "Require Rating"
      else
        status = "Bad"
      end

      post_j.rating_status = status

      post_j.save
    end

    render :text => %Q'
      <div class="QAsDet">Good <strong>(#{post_j.total_good})</strong></div>
      <div class="QAsDet">Bad <strong>(#{post_j.total_bad})</strong></div>'
  end
  
  # GET /post_jobs/1
  # GET /post_jobs/1.xml
  def show
    @post = Post.find(params[:id])
    @post_j = @post.post_job
    
    update_view_count(@post)
    posts_as = PostJob.with_school(@school)
    as_next = posts_as.next(@post_j.id).first
    as_prev = posts_as.previous(@post_j.id).first
    @next = as_next.post if as_next
    @prev = as_prev.post if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_j }
    end
  end

  def employment_infor
    @job_infors = JobInfor.find(:all, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
  end
  
  def show_job_infor
    job_infor_id = params[:job_infor_id]
    @job_infor = JobInfor.find(job_infor_id)
  end

  def add_job
    post_job_id = params[:post_job_id]
    post = Post.find(post_job_id)
    job_list = JobsList.find_or_create_by_user_id_and_post_job_id(current_user.id, post.post_job.id)
    job_lists = current_user.jobs_lists
    render :text => %Q'<span class="btmAddJob">
        <a title="My job list" class="thickbox" href="/post_jobs/my_job_list?height=400&amp;width=470" class = "thickbox" title = "My job list"><span>My job list</span></a>
      </span>'
  end

  def my_job_list
    @jobs_lists = current_user.jobs_lists
    render :layout => false
  end

  # GET /post_jobs/new
  # GET /post_jobs/new.xml
  def new
    @post_job = PostJob.new
    @post = Post.new
    @post_job.post = @post
    @post_job.job_type_id = JobType.first.id
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_job }
    end
  end

  # GET /post_jobs/1/edit
  def edit
  end

  # POST /post_jobs
  # POST /post_jobs.xml
  def create

    @post_job = PostJob.new(params[:post_job])
    post = Post.new(params[:post])
    post.user = current_user
    post.school_id = @school
    post.post_category_id = @type
    post.type_name = @class_name
    post.save
    @post_job.tag_list = params[:tag]
    @post_job.post = post

    if (params[:jobinfo] != nil)
      @post_job.job_files.build(params[:jobinfo].merge({:user_id => current_user.id}))
    else
      #If user does not upload file, records for these 3 files are created with empty url
      #user can upload these files later
      @post_job.job_files.build(params[:letter].merge({:user_id => current_user.id}))
      @post_job.job_files.build(params[:transcript].merge({:user_id => current_user.id}))
      @post_job.job_files.build(params[:resume].merge({:user_id => current_user.id}))
    end

    if @post_job.save
      notice "Your post was successfully created."
      redirect_to post_jobs_path + "?job_type_id=#{@post_job.job_type_id}"
    else
      error "Failed to create a new post."
      render :action => "new"
    end
  end

  # PUT /post_jobs/1
  # PUT /post_jobs/1.xml
  def update
    @post_job = PostJob.find(params[:id])

    if (@post_job.update_attributes(params[:post_job]) && @post_job.post.update_attributes(params[:post]))
      redirect_to my_post_user_url(current_user)
    end

  end

  # DELETE /post_jobs/1
  # DELETE /post_jobs/1.xml
  def destroy
    @post_job = PostJob.find(params[:id])
    @post_job.destroy

    redirect_to my_post_user_url(current_user)
  end
  def apply_job
    @post_job_id = params[:job_id]

    @post_job = PostJob.find(params[:job_id])

    render :layout => false
  end
  def save_letter

    cover_letter = JobFile.new
    
    @post_job = PostJob.find(params[:job_id])
    
    cover_letter = @post_job.job_files.build(:resume_cv => params[:cover_letter])
    cover_letter.category = "Cover letter"
    cover_letter.user_id = current_user.id


    @post_job.save

    render :text => cover_letter.resume_cv.url

  end

  def save_script

    transcript = JobFile.new

    @post_job = PostJob.find(params[:job_id])

    transcript = @post_job.job_files.build(:resume_cv => params[:transcript])
    transcript.category = "Transcript"
    transcript.user_id = current_user.id

    @post_job.save

    render :text => transcript.resume_cv.url

  end

  def save_resume

    resume = JobFile.new

    @post_job = PostJob.find(params[:job_id])

    resume = @post_job.job_files.build(:resume_cv => params[:resume])
    resume.category = "Resume"
    resume.user_id = current_user.id


    @post_job.save

    render :text => resume.resume_cv.url

  end
  
  private

  def get_variables
    @tags = PostJob.tag_counts
    @new_post_path = new_post_job_path
    @class_name = "PostJob"
    @type = PostCategory.find_by_class_name(@class_name).id
    @school = session[:your_school]
    @query = params[:search][:query] if params[:search]
  end

  def require_current_user
    post = Post.find(params[:id])
    @post_job = post.post_job
    @user ||= post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end

end
