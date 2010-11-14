# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class SchoolsController < ApplicationController
  require_role :admin
  layout 'admin'
  # GET /schools
  # GET /schools.xml
  def index
    @countries = Country.has_cities
    @country = @countries.first
    @states = @country.states
    @state = @states.first
    @cities = @state.cities
    @city = @cities.first
    
    if params[:school]
      @school = School.new(params[:school])
      if params[:state]
        country_id = params[:state][:country_id]
      end
      if params[:city]
        state_id = params[:city][:state_id]
      end
      city_id = params[:school][:city_id]
    end
    
    if country_id
      country = Country.find_by_id(country_id)
      @states = country.states
      @state = State.new
      @state.country_id = country_id
    end

    if state_id
      state = State.find_by_id(state_id)
      @cities = state.cities
      @city = City.new
      @city.state_id = state_id
    end

    cond = School.paginated_schools_conditions_with_search(params)
    @schools = School.paginate :include => [{:city => {:state => :country}}], :conditions => cond.to_sql, :page => params[:page], :per_page => 10

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schools }
    end
  end
  
  def state_or_city
    type = params[:type]
    country_id = params[:country_id]
    @countries = Country.has_cities
    @country = Country.find(country_id)
    @states = @country.states
    @state = @states.first
    @cities = @state.cities
    @city = @cities.first
    if type == "search"
      render :partial => "search_select_city"
    else
      render :partial => "select_city"
    end
  end
  
  def city
    type = params[:type]
    state_id = params[:state_id]
    @countries = Country.has_cities
    @state = State.find(state_id)
    @country = @state.country
    @states = @country.states
    @cities = @state.cities
    @city = @cities.first
    cities = City.find_all_by_state_id(state_id)
    if type == "search"
      render :partial => "search_select_city"
    else
      render :partial => "select_city"
    end
  end
  
  # GET /schools/1
  # GET /schools/1.xml
  def show
    @school = School.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @school }
    end
  end

  # GET /schools/new
  # GET /schools/new.xml
  def new
    @countries = Country.has_cities
    @country = @countries.first
    @states = @country.states
    @state = @states.first
    @cities = @state.cities
    @city = @cities.first
    @school = School.new
    @school.type_school = "University"
    @department_categories = DepartmentCategory.find(:all)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @school }
    end
  end

  # GET /schools/1/edit
  def edit
    @countries = Country.has_cities
    @school = School.find(params[:id])
    @department_categories = DepartmentCategory.find(:all)

    city = @school.city
    state = city.state
    country = city.country
    @states = country.states
    @cities = state.cities
  end

  # POST /schools
  # POST /schools.xml
  def create
    params[:school][:department_ids] = params[:department_select]
    @school = School.new(params[:school])
    respond_to do |format|
      if @school.save
        flash[:notice] = 'School was successfully created.'
        format.html { redirect_to(@school) }
        format.xml  { render :xml => @school, :status => :created, :location => @school }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /schools/1
  # PUT /schools/1.xml
  def update
    params[:school][:department_ids] = params[:department_select]
    params[:school][:department_ids] ||= []
    @school = School.find(params[:id])

    respond_to do |format|
      if @school.update_attributes(params[:school])
        flash[:notice] = 'School was successfully updated.'
        format.html { redirect_to(@school) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /schools/1
  # DELETE /schools/1.xml
  def destroy
    @school = School.find(params[:id])
    @school.destroy

    respond_to do |format|
      format.html { redirect_to(schools_url) }
      format.xml  { head :ok }
    end
  end
end
