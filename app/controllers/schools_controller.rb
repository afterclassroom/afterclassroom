# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class SchoolsController < ApplicationController
  require_role :admin
  layout 'admin'
  # GET /schools
  # GET /schools.xml
  def index
    @country_name = 'Select Country'
    @state_name = 'Select State'
    @city_name = 'Select City'
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
      @country_name = country.printable_name
      @states = country.states
      @state = State.new
      @state.country_id = country_id
    end

    if state_id
      state = State.find_by_id(state_id)
      @cities = state.cities
      @state_name = state.name
      @city = City.new
      @city.state_id = state_id
    end

    if city_id
      @city_name = City.find_by_id(city_id).name
    end
    
    @countries = Country.has_cities
    cond = School.paginated_schools_conditions_with_search(params)
    @schools = School.paginate :include => [{:city => {:state => :country}}], :conditions => cond.to_sql, :page => params[:page], :per_page => 10

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schools }
    end
  end
  
  def state_or_city
    country_id = params[:country_id]
    states = State.find_all_by_country_id(country_id)
    if states.size > 0
      render :partial => "state", :locals => {
        :states => states
      }
    else
      cities = City.find_all_by_state_id(country_id)
      render :partial => "city", :locals => {
        :cities => cities
      }
    end
  end
  
  def city
    state_id = params[:state_id]
    cities = City.find_all_by_state_id(state_id)
    render :partial => "city", :locals => {
      :cities => cities
    }
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
    @school = School.new
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
    @department_name = ""
    for department in @school.departments
      @department_name += department.name + ", "
    end
    city = @school.city
    @city_name = city.name
    state = city.state
    @city = City.new
    @city.state_id = state.id
    country = city.country
    @state = State.new
    @state.country_id = country.id
    @state_name = state.name
    @country_name = country.name
    @states = country.states
    @cities = state.cities
  end

  # POST /schools
  # POST /schools.xml
  def create
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
