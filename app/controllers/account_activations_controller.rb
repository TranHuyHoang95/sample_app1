class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t "user_mailer.message.activated"
      redirect_to user
    else
      flash[:danger] = "user_mailer.message.invalid_link"
      redirect_to root_url
    end
  end
end
