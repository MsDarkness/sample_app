class SessionsController < ApplicationController

  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
	
		if ((params[:remember_me]) == "true")
			flash[:success] = "Please use caution when chosing to be remembered"
			sign_in_remembered user #for when remember me is checked
		else
			sign_in_nonremembered user # for when remember me is not checked
		end
      redirect_to user
    end
  end

  def destroy
	sign_out
    redirect_to root_path
  end
end