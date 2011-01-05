# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class TeamupCategoriesController < ApplicationController
  require_role :admin
  layout 'admin'
  # GET /teamup_categories
  # GET /teamup_categories.xml
  def index
    @teamup_categories = TeamupCategory.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teamup_categories }
    end
  end

  # GET /teamup_categories/1
  # GET /teamup_categories/1.xml
  def show
    @teamup_category = TeamupCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @teamup_category }
    end
  end

  # GET /teamup_categories/new
  # GET /teamup_categories/new.xml
  def new
    @teamup_category = TeamupCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @teamup_category }
    end
  end

  # GET /teamup_categories/1/edit
  def edit
    @teamup_category = TeamupCategory.find(params[:id])
  end

  # POST /teamup_categories
  # POST /teamup_categories.xml
  def create
    @teamup_category = TeamupCategory.new(params[:teamup_category])
    @teamup_category.label = to_slug(@teamup_category.name)

    respond_to do |format|
      if @teamup_category.save
        flash[:notice] = 'TeamupCategory was successfully created.'
        format.html { redirect_to(@teamup_category) }
        format.xml  { render :xml => @teamup_category, :status => :created, :location => @teamup_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @teamup_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /teamup_categories/1
  # PUT /teamup_categories/1.xml
  def update
    @teamup_category = TeamupCategory.find(params[:id])

    respond_to do |format|
      if @teamup_category.update_attributes(params[:teamup_category])
        flash[:notice] = 'TeamupCategory was successfully updated.'
        format.html { redirect_to(@teamup_category) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @teamup_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /teamup_categories/1
  # DELETE /teamup_categories/1.xml
  def destroy
    @teamup_category = TeamupCategory.find(params[:id])
    @teamup_category.destroy

    respond_to do |format|
      format.html { redirect_to(teamup_categories_url) }
      format.xml  { head :ok }
    end
  end
end
