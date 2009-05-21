# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class EducationCategoriesController < ApplicationController
  require_role :admin
  layout 'admin'
  # GET /education_categories
  # GET /education_categories.xml
  def index
    @education_categories = EducationCategory.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @education_categories }
    end
  end

  # GET /education_categories/1
  # GET /education_categories/1.xml
  def show
    @education_category = EducationCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @education_category }
    end
  end

  # GET /education_categories/new
  # GET /education_categories/new.xml
  def new
    @education_category = EducationCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @education_category }
    end
  end

  # GET /education_categories/1/edit
  def edit
    @education_category = EducationCategory.find(params[:id])
  end

  # POST /education_categories
  # POST /education_categories.xml
  def create
    @education_category = EducationCategory.new(params[:education_category])

    respond_to do |format|
      if @education_category.save
        flash[:notice] = 'EducationCategory was successfully created.'
        format.html { redirect_to(@education_category) }
        format.xml  { render :xml => @education_category, :status => :created, :location => @education_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @education_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /education_categories/1
  # PUT /education_categories/1.xml
  def update
    @education_category = EducationCategory.find(params[:id])

    respond_to do |format|
      if @education_category.update_attributes(params[:education_category])
        flash[:notice] = 'EducationCategory was successfully updated.'
        format.html { redirect_to(@education_category) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @education_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /education_categories/1
  # DELETE /education_categories/1.xml
  def destroy
    @education_category = EducationCategory.find(params[:id])
    @education_category.destroy

    respond_to do |format|
      format.html { redirect_to(education_categories_url) }
      format.xml  { head :ok }
    end
  end
end
