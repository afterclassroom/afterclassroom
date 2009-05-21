# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class AwarenessIssuesController < ApplicationController
  require_role :admin
  layout 'admin'# GET /awareness_issues
  # GET /awareness_issues.xml
  def index
    @awareness_issues = AwarenessIssue.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @awareness_issues }
    end
  end

  # GET /awareness_issues/1
  # GET /awareness_issues/1.xml
  def show
    @awareness_issue = AwarenessIssue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @awareness_issue }
    end
  end

  # GET /awareness_issues/new
  # GET /awareness_issues/new.xml
  def new
    @awareness_issue = AwarenessIssue.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @awareness_issue }
    end
  end

  # GET /awareness_issues/1/edit
  def edit
    @awareness_issue = AwarenessIssue.find(params[:id])
  end

  # POST /awareness_issues
  # POST /awareness_issues.xml
  def create
    @awareness_issue = AwarenessIssue.new(params[:awareness_issue])

    respond_to do |format|
      if @awareness_issue.save
        flash[:notice] = 'AwarenessIssue was successfully created.'
        format.html { redirect_to(@awareness_issue) }
        format.xml  { render :xml => @awareness_issue, :status => :created, :location => @awareness_issue }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @awareness_issue.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /awareness_issues/1
  # PUT /awareness_issues/1.xml
  def update
    @awareness_issue = AwarenessIssue.find(params[:id])

    respond_to do |format|
      if @awareness_issue.update_attributes(params[:awareness_issue])
        flash[:notice] = 'AwarenessIssue was successfully updated.'
        format.html { redirect_to(@awareness_issue) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @awareness_issue.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /awareness_issues/1
  # DELETE /awareness_issues/1.xml
  def destroy
    @awareness_issue = AwarenessIssue.find(params[:id])
    @awareness_issue.destroy

    respond_to do |format|
      format.html { redirect_to(awareness_issues_url) }
      format.xml  { head :ok }
    end
  end
end
