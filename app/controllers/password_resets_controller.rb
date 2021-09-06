class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user,
                :check_expiration, only: %i(edit update)

  def new; end

  def create
    if @user = User.find_by(email: params[:password_reset][:email].downcase)
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "forgot_password.sent_password_reset"
      redirect_to root_url
    else
      flash.now[:danger] = t "forgot_password.email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t("forgot_password.cant_empty"))
      render :edit
    elsif @user.update(user_params)
      log_in @user
      @user.update_column :reset_digest, nil
      flash[:success] = t "forgot_password.has_been_reset"
      redirect_to @user
    else
      flash.now[:danger] = t "update_failed"
      render :edit
    end
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  private

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "user_nil"
    redirect_to root_path
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(
      :reset, params[:id]
    )

    flash[:danger] = t "forgot_password.invalid_user"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "forgot_password.has_expired"
    redirect_to new_password_reset_url
  end
end
