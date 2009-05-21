# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class StatesController < ApplicationController
  require_role :admin
  layout 'admin'
  # GET /states
  # GET /states.xml
  def index
    @country_name = 'Select Country'
    if params[:state]
      @state = State.new(params[:state])
      if params[:state][:country_id]
        @country_name = Country.find_by_id(params[:state][:country_id]).printable_name     
      end
    end
    
    @countries = Country.find(:all)
    cond = State.paginated_states_conditions_with_search(params)
    @states = State.paginate :conditions => cond.to_sql, :page => params[:page], :per_page => 10
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @states }
    end
  end

  # GET /states/1
  # GET /states/1.xml
  def show
    @state = State.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @state }
    end
  end

  # GET /states/new
  # GET /states/new.xml
  def new
    @countries = Country.find(:all)
    usa = Country.find_by_iso3('USA')
    @state = State.new
    @state.country_id = usa.id
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @state }
    end
  end

  # GET /states/1/edit
  def edit
    @countries = Country.find(:all)
    @state = State.find(params[:id])
  end

  # POST /states
  # POST /states.xml
  def create
    @state = State.new(params[:state])

    respond_to do |format|
      if @state.save
        flash[:notice] = 'State was successfully created.'
        format.html { redirect_to(@state) }
        format.xml  { render :xml => @state, :status => :created, :location => @state }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @state.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /states/1
  # PUT /states/1.xml
  def update
    @state = State.find(params[:id])

    respond_to do |format|
      if @state.update_attributes(params[:state])
        flash[:notice] = 'State was successfully updated.'
        format.html { redirect_to(@state) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @state.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /states/1
  # DELETE /states/1.xml
  def destroy
    @state = State.find(params[:id])
    @state.destroy

    respond_to do |format|
      format.html { redirect_to(states_url) }
      format.xml  { head :ok }
    end
  end
end
