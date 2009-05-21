# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class HousingCategoriesController < ApplicationController
  require_role :admin
  layout 'admin'
  # GET /housing_categories
  # GET /housing_categories.xml
  def index
    @housing_categories = HousingCategory.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @housing_categories }
    end
  end

  # GET /housing_categories/1
  # GET /housing_categories/1.xml
  def show
    @housing_category = HousingCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @housing_category }
    end
  end

  # GET /housing_categories/new
  # GET /housing_categories/new.xml
  def new
    @housing_category = HousingCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @housing_category }
    end
  end

  # GET /housing_categories/1/edit
  def edit
    @housing_category = HousingCategory.find(params[:id])
  end

  # POST /housing_categories
  # POST /housing_categories.xml
  def create
    @housing_category = HousingCategory.new(params[:housing_category])

    respond_to do |format|
      if @housing_category.save
        flash[:notice] = 'HousingCategory was successfully created.'
        format.html { redirect_to(@housing_category) }
        format.xml  { render :xml => @housing_category, :status => :created, :location => @housing_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @housing_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /housing_categories/1
  # PUT /housing_categories/1.xml
  def update
    @housing_category = HousingCategory.find(params[:id])

    respond_to do |format|
      if @housing_category.update_attributes(params[:housing_category])
        flash[:notice] = 'HousingCategory was successfully updated.'
        format.html { redirect_to(@housing_category) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @housing_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /housing_categories/1
  # DELETE /housing_categories/1.xml
  def destroy
    @housing_category = HousingCategory.find(params[:id])
    @housing_category.destroy

    respond_to do |format|
      format.html { redirect_to(housing_categories_url) }
      format.xml  { head :ok }
    end
  end
end
