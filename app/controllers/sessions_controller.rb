class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end
  
  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    #user = User.authenticate("", "")
    if user.nil?
      flash[:error] = "Invalid user/password combination."
      @title = "Sign in"
      redirect_to signin_path
    elsif user.account_expired?
      redirect_to accountexpired_path
    else
      sign_in user
      redirect_to user
    end
    
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end