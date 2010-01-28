# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class UsersSelectSchoolController < ApplicationController
  def show
    @countries = Country.has_cities
    if session[:your_school]
      @school = School.find(session[:your_school])
      @city = @school.city
      @state = @city.state
      @country = @state.country
      @states = @country.states
      @cities = @state.cities
      @schools = @city.schools
    else
      @country = @countries.first
      @states = @country.states
      @state = @states.first
      @cities = @state.cities
      @city = @cities.first
      @schools = @city.schools
      @school = @schools.first
    end
    render :layout => false
  end

  def update_form
    type = params[:type]
    id = params[:id]
    @countries = Country.has_cities
    case type
      when "country"
        @country = Country.find(id)
        @states = @country.states
        @state = @states.first
        @cities = @state.cities
        @city = @cities.first
        @schools = @city.schools
        @school = @schools.first
      when "state"
        @state = State.find(id)
        @country = @state.country
        @states = @country.states
        @cities = @state.cities
        @city = @cities.first
        @schools = @city.schools
        @school = @schools.first
      when "city"
        @city = City.find(id)
        @state = @city.state
        @country = @state.country
        @states = @country.states
        @cities = @state.cities
        @schools = @city.schools
        @school = @schools.first
    end
    render :layout => false
  end

  def list_school
    alphabet = params[:alphabet]
    city_id = params[:city_id]
    if alphabet == ""
      @schools = City.find(city_id).schools
    else
      @schools = School.list_school(city_id, alphabet)
    end
    render :layout => false
  end
end
