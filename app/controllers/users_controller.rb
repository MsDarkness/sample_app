class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
	
		if signed_in? #show all users if user is signed in
			@get_Users = User.all
		else # if not signed in, just show public profiles
			@get_Users = User.find_all_by_publicprofile(true)
		end
  end

  def show
		if signed_in? 
			@user = User.find(params[:id])
			@microposts = @user.microposts.paginate(:page => params[:page])
			@title = @user.name
		else
			if(User.find(params[:id]).publicprofile)
				@user = User.find(params[:id])
				@title = @user.name
			else
				deny_access
			end
		end
  end

  def new
    @title = "Sign up"
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end