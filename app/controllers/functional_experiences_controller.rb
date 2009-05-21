# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class FunctionalExperiencesController < ApplicationController
  require_role :admin
  layout 'admin'
  # GET /functional_experiences
  # GET /functional_experiences.xml
  def index
    @functional_experiences = FunctionalExperience.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @functional_experiences }
    end
  end

  # GET /functional_experiences/1
  # GET /functional_experiences/1.xml
  def show
    @functional_experience = FunctionalExperience.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @functional_experience }
    end
  end

  # GET /functional_experiences/new
  # GET /functional_experiences/new.xml
  def new
    @functional_experience = FunctionalExperience.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @functional_experience }
    end
  end

  # GET /functional_experiences/1/edit
  def edit
    @functional_experience = FunctionalExperience.find(params[:id])
  end

  # POST /functional_experiences
  # POST /functional_experiences.xml
  def create
    @functional_experience = FunctionalExperience.new(params[:functional_experience])

    respond_to do |format|
      if @functional_experience.save
        flash[:notice] = 'FunctionalExperience was successfully created.'
        format.html { redirect_to(@functional_experience) }
        format.xml  { render :xml => @functional_experience, :status => :created, :location => @functional_experience }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @functional_experience.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /functional_experiences/1
  # PUT /functional_experiences/1.xml
  def update
    @functional_experience = FunctionalExperience.find(params[:id])

    respond_to do |format|
      if @functional_experience.update_attributes(params[:functional_experience])
        flash[:notice] = 'FunctionalExperience was successfully updated.'
        format.html { redirect_to(@functional_experience) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @functional_experience.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /functional_experiences/1
  # DELETE /functional_experiences/1.xml
  def destroy
    @functional_experience = FunctionalExperience.find(params[:id])
    @functional_experience.destroy

    respond_to do |format|
      format.html { redirect_to(functional_experiences_url) }
      format.xml  { head :ok }
    end
  end
end
