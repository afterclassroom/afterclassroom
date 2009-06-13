# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class CitiesController < ApplicationController
  require_role :admin
  layout 'admin'
  # GET /cities
  # GET /cities.xml
  def index
    @country_name = 'Select Country'
    @state_name = 'Select State'
    if params[:city]
      @city = City.new(params[:city])
      if params[:city][:country_id]
        country_id = params[:city][:country_id]
      end
      if params[:city][:state_id]
        state_id = params[:city][:state_id]
      end
    end

    if country_id
      @country_name = Country.find_by_id(country_id).printable_name     
    end
    
    if state_id
      @state_name = State.find_by_id(state_id).name
    end
    
    @countries = Country.find(:all)
    cond = City.paginated_cities_conditions_with_search(params)
    @states = country_id ? State.find_all_by_country_id(country_id) : nil
    @cities = City.paginate :conditions => cond.to_sql, :page => params[:page], :per_page => 10

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cities }
    end
  end
  
  def state
    country_id = params[:country_id]
    states = State.find_all_by_country_id(country_id)
    render :partial => "state", :locals => {
      :states => states
    }
  end

  # GET /cities/1
  # GET /cities/1.xml
  def show
    @city = City.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @city }
    end
  end

  # GET /cities/new
  # GET /cities/new.xml
  def new
    @countries = Country.find(:all)
    @city = City.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @city }
    end
  end

  # GET /cities/1/edit
  def edit
    @countries = Country.find(:all)
    @city = City.find(params[:id])
    @states = State.find_all_by_country_id(@city.country_id)
  end

  # POST /cities
  # POST /cities.xml
  def create
    @city = City.new(params[:city])

    respond_to do |format|
      if @city.save
        flash[:notice] = 'City was successfully created.'
        format.html { redirect_to(@city) }
        format.xml  { render :xml => @city, :status => :created, :location => @city }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @city.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cities/1
  # PUT /cities/1.xml
  def update
    @city = City.find(params[:id])

    respond_to do |format|
      if @city.update_attributes(params[:city])
        flash[:notice] = 'City was successfully updated.'
        format.html { redirect_to(@city) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @city.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cities/1
  # DELETE /cities/1.xml
  def destroy
    @city = City.find(params[:id])
    @city.destroy

    respond_to do |format|
      format.html { redirect_to(cities_url) }
      format.xml  { head :ok }
    end
  end
end
