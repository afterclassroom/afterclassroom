class AwarenessTypesController < ApplicationController
  require_role :admin
  layout 'admin'
  def index
    @awareness_types = AwarenessType.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @awareness_types }
    end
  end
  
  def show
    @awareness_type = AwarenessType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @awareness_type }
    end
  end
  
  def new
    @awareness_type = AwarenessType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @awareness_type }
    end
  end

  def edit
    @awareness_type = AwarenessType.find(params[:id])
  end
  
   def create
    @awareness_type = AwarenessType.new(params[:awareness_type])

    respond_to do |format|
      if @awareness_type.save
        flash[:notice] = 'AwarenessType was successfully created.'
        format.html { redirect_to(@awareness_type) }
        format.xml  { render :xml => @awareness_type, :status => :created, :location => @awareness_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @awareness_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @awareness_type = AwarenessType.find(params[:id])

    respond_to do |format|
      if @awareness_type.update_attributes(params[:awareness_type])
        flash[:notice] = 'AwarenessType was successfully updated.'
        format.html { redirect_to(@awareness_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @awareness_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @awareness_type = AwarenessType.find(params[:id])
    @awareness_type.destroy

    respond_to do |format|
      format.html { redirect_to(awareness_types_url) }
      format.xml  { head :ok }
    end
  end

end
