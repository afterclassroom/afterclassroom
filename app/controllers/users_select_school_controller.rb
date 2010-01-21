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
  end

  def update_form  
    @city = City.find(params[:city])
    @state = @city.state
    @country = @state.country

    @countries = Country.has_cities
    @states = @country.states
    @cities = @state.cities
    @schools = @city.schools
    @school = @schools.first
  end

  def list_school
    alphabet = params[:alphabet]
    city_id = params[:city_id]
    if alphabet == ""
      @schools = City.find(city_id).schools
    else
      @schools = School.list_school(city_id, alphabet)
    end
  end
end
