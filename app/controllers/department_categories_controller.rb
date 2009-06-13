# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class DepartmentCategoriesController < ApplicationController
  require_role :admin
  layout 'admin'
  # GET /department_categories
  # GET /department_categories.xml
  def index
    @department_categories = DepartmentCategory.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @department_categories }
    end
  end

  # GET /department_categories/1
  # GET /department_categories/1.xml
  def show
    @department_category = DepartmentCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @department_category }
    end
  end

  # GET /department_categories/new
  # GET /department_categories/new.xml
  def new
    @department_category = DepartmentCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @department_category }
    end
  end

  # GET /department_categories/1/edit
  def edit
    @department_category = DepartmentCategory.find(params[:id])
  end

  # POST /department_categories
  # POST /department_categories.xml
  def create
    @department_category = DepartmentCategory.new(params[:department_category])

    respond_to do |format|
      if @department_category.save
        flash[:notice] = 'DepartmentCategory was successfully created.'
        format.html { redirect_to(@department_category) }
        format.xml  { render :xml => @department_category, :status => :created, :location => @department_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @department_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /department_categories/1
  # PUT /department_categories/1.xml
  def update
    @department_category = DepartmentCategory.find(params[:id])

    respond_to do |format|
      if @department_category.update_attributes(params[:department_category])
        flash[:notice] = 'DepartmentCategory was successfully updated.'
        format.html { redirect_to(@department_category) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @department_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /department_categories/1
  # DELETE /department_categories/1.xml
  def destroy
    @department_category = DepartmentCategory.find(params[:id])
    @department_category.destroy

    respond_to do |format|
      format.html { redirect_to(department_categories_url) }
      format.xml  { head :ok }
    end
  end
end
