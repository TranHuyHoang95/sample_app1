class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:sessions][:email].downcase
    return check_activated user if user&.authenticate(
      params[:sessions][:password]
    )

    flash.now[:danger] = t "invalid_login"
    render :new
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def handle_remember user
    params[:sessions][:remember_me] == "1" ? remember(user) : forget(user)
  end

  def check_activated user
    if user.activated?
      log_in user
      handle_remember user
      redirect_back_or user
    else
      flash[:warning] = t "unactivate_login_failed"
      redirect_to root_url
    end
  end
end
