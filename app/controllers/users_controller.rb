class UsersController < ApplicationController
  before_filter :admin_required, :except => [:index, :show, :slideshows]
    
  # GET /users
  def index
    @users = User.all(:order => :name)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    @entries = @user.entries if @user
    @projects = @user.projects if @user

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /users/new
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'Member was successfully created.'
        format.html { redirect_to(@user) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Member was successfully updated.'
        format.html { redirect_to(@user) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
    end
  end
  
  def slideshows
    @users=User.all.map{|u| u.slideshare_user.blank? ? nil : u}.compact.sort_by(&:name) 
  end
end
