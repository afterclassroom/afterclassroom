class HelpInfosController < ApplicationController
  # GET /help_infos
  # GET /help_infos.xml
  def index
    @help_infos = HelpInfo.all
    @help_info = HelpInfo.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @help_infos }
    end
  end

  # GET /help_infos/1
  # GET /help_infos/1.xml
  def show
    @help_infos = HelpInfo.all
    @help_info = HelpInfo.new

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @help_info }
    end
  end

  # GET /help_infos/new
  # GET /help_infos/new.xml
  def new
    @help_info = HelpInfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @help_info }
    end
  end

  # GET /help_infos/1/edit
  def edit
    @help_info = HelpInfo.find(params[:id])
  end

  # POST /help_infos
  # POST /help_infos.xml
  def create
    @help_info = HelpInfo.new(params[:help_info])

    respond_to do |format|
      if @help_info.save
        format.html { redirect_to(@help_info, :notice => 'Help info was successfully created.') }
        format.xml  { render :xml => @help_info, :status => :created, :location => @help_info }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @help_info.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /help_infos/1
  # PUT /help_infos/1.xml
  def update
    @help_info = HelpInfo.find(params[:id])

    respond_to do |format|
      if @help_info.update_attributes(params[:help_info])
        format.html { redirect_to(@help_info, :notice => 'Help info was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @help_info.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /help_infos/1
  # DELETE /help_infos/1.xml
  def destroy
    @help_info = HelpInfo.find(params[:id])
    @help_info.destroy

    respond_to do |format|
      format.html { redirect_to(help_infos_url) }
      format.xml  { head :ok }
    end
  end
end
