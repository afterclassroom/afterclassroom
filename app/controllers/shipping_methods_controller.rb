# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class ShippingMethodsController < ApplicationController
  require_role :admin
  layout 'admin'
  # GET /shipping_methods
  # GET /shipping_methods.xml
  def index
    @shipping_methods = ShippingMethod.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @shipping_methods }
    end
  end

  # GET /shipping_methods/1
  # GET /shipping_methods/1.xml
  def show
    @shipping_method = ShippingMethod.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @shipping_method }
    end
  end

  # GET /shipping_methods/new
  # GET /shipping_methods/new.xml
  def new
    @shipping_method = ShippingMethod.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @shipping_method }
    end
  end

  # GET /shipping_methods/1/edit
  def edit
    @shipping_method = ShippingMethod.find(params[:id])
  end

  # POST /shipping_methods
  # POST /shipping_methods.xml
  def create
    @shipping_method = ShippingMethod.new(params[:shipping_method])

    respond_to do |format|
      if @shipping_method.save
        flash[:notice] = 'ShippingMethod was successfully created.'
        format.html { redirect_to(@shipping_method) }
        format.xml  { render :xml => @shipping_method, :status => :created, :location => @shipping_method }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @shipping_method.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /shipping_methods/1
  # PUT /shipping_methods/1.xml
  def update
    @shipping_method = ShippingMethod.find(params[:id])

    respond_to do |format|
      if @shipping_method.update_attributes(params[:shipping_method])
        flash[:notice] = 'ShippingMethod was successfully updated.'
        format.html { redirect_to(@shipping_method) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @shipping_method.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /shipping_methods/1
  # DELETE /shipping_methods/1.xml
  def destroy
    @shipping_method = ShippingMethod.find(params[:id])
    @shipping_method.destroy

    respond_to do |format|
      format.html { redirect_to(shipping_methods_url) }
      format.xml  { head :ok }
    end
  end
end
