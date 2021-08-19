class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:sessions][:email].downcase)
    if user&.authenticate(params[:sessions][:password])
      log_in user
      get_action
      redirect_to user
    else
      flash.now[:danger] = t "invalid_login"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
  
  def get_action
    params[:sessions][:remember_me] == "1" ? remember(user) : forget(user)
  end
end
