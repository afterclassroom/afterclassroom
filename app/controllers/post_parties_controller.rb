# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostPartiesController < ApplicationController
  include Viewable

  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search, :tag, :prefer, :add_party, :my_party_list, :show_rsvp]
  before_filter :login_required, :except => [:index, :show, :search, :tag, :prefer, :show_rsvp]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search, :tag]
  after_filter :store_go_back_url, :only => [:index, :show, :search, :tag]
  # GET /post_parties
  # GET /post_parties.xml
  
  def index
    @rating_status = params[:rating_status]
    @rating_status ||= ""
    @posts = PostParty.paginated_post_conditions_with_option(params, @school, @rating_status)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  def rate
    rating = params[:rating]
    post = Post.find(params[:post_id])
    post_p = post.post_party
    post_p.rate rating.to_i, current_user
    # Update rating status
    score_good = post_p.score_good
    score_ok = post_p.score_ok
    score_bad = post_p.score_bad

    if score_good == score_ok && score_ok == score_bad
      status = "Require Rating"
    else
      sort_rating_status = {"Good" => score_good, "It's Ok" => score_ok, "Bad" => score_bad}
      arr_rating_status = sort_rating_status.sort { |a, b| a[1] <=> b[1] }
      status = arr_rating_status.last.first
    end

    post_p.rating_status = status

    post_p.save

    render :text => %Q'
      <div class="qashdU">
        <a href="javascript:;" class="vtip" title="#{Setting.get(:str_rated)}">#{post_p.total_good}</a>
      </div>
      <div class="cheap">
        <a href="javascript:;" class="vtip" title="#{Setting.get(:str_rated)}">It\'s Ok(#{post_p.total_ok})</a>
      </div>
      <div class="qashdD">
        <a href="javascript:;" class="vtip" title="#{Setting.get(:str_rated)}">#{post_p.total_bad}</a>
      </div>
      <script>
        vtip();
      </script>'
  end

  def require_rate
    rating = params[:rating]
    post = Post.find(params[:post_id])
    post_p = post.post_party
    if !Postparty.find_rated_by(current_user).include?(post_p)
      post_p.rate rating.to_i, current_user
      # Update rating status
      score_good = post_p.score_good
      score_ok = post_p.score_ok
      score_bad = post_p.score_bad

      if score_good == score_ok && score_ok == score_bad
        status = "Require Rating"
      else
        sort_rating_status = {"Good" => score_good, "It's Ok" => score_ok, "Bad" => score_bad}
        arr_rating_status = sort_rating_status.sort { |a, b| a[1] <=> b[1] }
        status = arr_rating_status.last.first
      end

      post_p.rating_status = status

      post_p.save
    end

    render :text => %Q'
      <div class="qashdU">
        <a href="javascript:;">#{post_p.total_good}</a>
      </div>
      <div class="cheap">
        <a href="javascript:;">It\'s Ok(#{post_p.total_ok})</a>
      </div>
      <div class="qashdD">
        <a href="javascript:;">#{post_p.total_bad}</a>
      </div>'
  end
  
  def tag
    tag_id = params[:tag_id]
    @tag = Tag.find(tag_id)
    @posts = PostParty.paginated_post_conditions_with_tag(params, @school, @tag.name)
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

  # GET /post_parties/1
  # GET /post_parties/1.xml
  def show
    @post = Post.find(params[:id])
    @post_party = @post.post_party
    update_view_count(@post)
    posts_as = PostParty.with_school(@school)
    as_next = posts_as.next(@post_party.id).first
    as_prev = posts_as.previous(@post_party.id).first
    @next = as_next.post if as_next
    @prev = as_prev.post if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_party }
    end
  end
  
  def add_party
    post_party_id = params[:post_party_id]
    post = Post.find(post_party_id)
    party_list = PartysList.find_or_create_by_user_id_and_post_party_id(current_user.id, post.post_party.id)
    party_lists = current_user.partys_lists
    render :text => %Q'<span class="btmPartyList">
        <a title="My party list" class="thickbox" href="/post_parties/my_party_list?height=400&amp;width=470" class = "thickbox" title = "My party list"><span>My party list</span></a>
      </span>'
  end

  def my_party_list
    @partys_lists = current_user.partys_lists
    render :layout => false
  end

  def show_rsvp
    @post = Post.find(params[:post_id])
    render :layout => false
  end

  def create_rsvp
    post = Post.find(params[:post_id])
    post_party_rsvp = PostPartyRsvp.new
    post_party_rsvp.where = params[:where]
    post_party_rsvp.when = params[:when]
    post_party_rsvp.first_name = params[:first_name]
    post_party_rsvp.last_name = params[:last_name]
    post_party_rsvp.email = params[:email]
    post_party_rsvp.tel = params[:tel]
    post_party_rsvp.message = params[:message]
    post_party_rsvp.save
    post.post_party.post_party_rsvps << post_party_rsvp
    render :text => "Success"
  end

  # GET /post_parties/new
  # GET /post_parties/new.xml
  def new
    @post_party = PostParty.new
    @post = Post.new
    @post_party.post = @post
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_party }
    end
  end

  # GET /post_parties/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /post_parties
  # POST /post_parties.xml
  def create
    params[:post_party][:party_type_ids] = params[:party_type]
    @post_party = PostParty.new(params[:post_party])
    post = Post.new(params[:post])
    post.user = current_user
    post.school_id = @school
    post.post_category_id = @type
    post.type_name = @class_name
    post.save
    @post_party.tag_list = params[:tag]
    @post_party.post = post
    if @post_party.save
      notice "Your post was successfully created."
      redirect_to post_parties_path
    else
      error "Failed to create a new post."
      render :action => "new"
    end
  end

  # PUT /post_parties/1
  # PUT /post_parties/1.xml
  def update
    params[:post_party][:party_type_ids] = params[:party_type]
    params[:post_party][:party_type_ids] ||= []
    @post_party = PostParty.find(params[:id])

    if (@post_party.update_attributes(params[:post_party]) && @post_party.post.update_attributes(params[:post]))
      redirect_to my_post_user_url(current_user)
    end
  end

  # DELETE /post_parties/1
  # DELETE /post_parties/1.xml
  def destroy
    @post_party = PostParty.find(params[:id])
    @post_party.destroy

    redirect_to my_post_user_url(current_user)
  end
  
  def prefer
    render :layout => false
  end
  
  private

  def get_variables
    @tags = PostParty.tag_counts
    @new_post_path = new_post_party_path
    @class_name = "PostParty"
    @type = PostCategory.find_by_class_name(@class_name).id
    @school = session[:your_school]
    @query = params[:search][:query] if params[:search]
  end

  def require_current_user
    post = Post.find(params[:id])
    @post_party = post.post_party
    @user ||= post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
   
 end
