# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class UsersSelectSchoolController < ApplicationController
  before_filter :get_variables, :only => [:update_form, :update_form_signup]
  
  def show
    @alphabet = "All"
		@alphabet_city = "All"
    @countries = Country.has_cities
    if session[:your_school]
      @school = School.find(session[:your_school])
			@type_school = @school.type_school
      @city = @school.city
      @state = @city.state
      @country = @state.country
      @states = @country.states.has_cities
      @cities = @state.cities
      @schools = @city.schools.where(:type_school => @type_school)
    else
      @country = @countries.first
			@type_school = "University"
      @states = @country.states.has_cities
      @state = @states.first
      @cities = @state.cities
      @city = @cities.first
      @schools = @city.schools.where(:type_school => @type_school)
      @school = @schools.first
    end
    render :layout => false
  end

  def update_form
    render :layout => false
  end

  def update_form_signup
    render :layout => false
  end

  def list_school
		state_id = params[:state_id]
    city_id = params[:city_id]
		@type_school = params[:type_school]
    @alphabet = params[:alphabet]
		@alphabet_city = params[:alphabet_city]
    @countries = Country.has_cities
		if city_id != "" 
			@city = City.find(city_id)
    	@state = @city.state
		elsif state_id != ""
			@state = State.find(state_id)
		end
    @country = @state.country
    @states = @country.states.has_cities
    @cities = @state.cities.with_alphabet(@alphabet_city)
		@city = @cities.first if @city.nil?
    if @alphabet == ""
      @schools = City.find(city_id).schools.where(:type_school => @type_school)
    else
      @schools = School.list_school(city_id, @alphabet, @type_school)
    end
    @school ||= @schools.first if @schools.size > 0
    render :layout => false
  end

  private

  def get_variables
    type = params[:type]
    id = params[:id]
    @alphabet = "All"
		@alphabet_city = "All"
    @countries = Country.has_cities
		@type_school = params[:type_school]
    case type
      when "country"
        @country = Country.find(id)
        @states = @country.states.has_cities
        @state = @states.first
        @cities = @state.cities
        @city = @cities.first
        if @type_school
        	@schools = @city.schools.where(:type_school => @type_school)
        else
        	@schools = @city.schools
        end
        @school = @schools.first
      when "state"
        @state = State.find(id)
        @country = @state.country
        @states = @country.states.has_cities
        @cities = @state.cities
        @city = @cities.first
        if @type_school
        	@schools = @city.schools.where(:type_school => @type_school)
        else
        	@schools = @city.schools
        end
        @school = @schools.first
      when "city"
        @city = City.find(id)
        @state = @city.state
        @country = @state.country
        @states = @country.states.has_cities
        @cities = @state.cities
        if @type_school
        	@schools = @city.schools.where(:type_school => @type_school)
        else
        	@schools = @city.schools
        end
        @school = @schools.first
    end
  end
end
