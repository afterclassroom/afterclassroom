# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class UsersSelectSchoolController < ApplicationController
  def show
    @countries = Country.has_cities
  end
  
  def state_or_city
    country_id = params[:country_id]
    @model_name = params[:model]
    @states = State.find_all_by_country_id(country_id)
    if @states.size <= 0
      render :action => "city"
    end
  end

  def city
    state_id = params[:state_id]
    @model_name = params[:model]
    @cities = City.find_all_by_state_id(state_id)
  end

  def school
    city_id = params[:city_id]
    @model_name = params[:model]
    @get_department = params[:get_department]
    @schools_university = School.find_all_by_city_id_and_type_school(city_id, 'University')
    @schools_college = School.find_all_by_city_id_and_type_school(city_id, 'College')
  end

  def department
    school_id = params[:school_id]
    @departments = School.find(school_id).departments.find(:all, :order => "department_category_id")
  end
end
