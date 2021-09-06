class UsersController < ApplicationController
  before_action :load_user, only: %i(show edit update)
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :check_permission, only: :destroy

  def index
    @users = User.activated.paginate(page: params[:page],
      per_page: Settings.per_page.user).order_by_id
  end

  def new
    @user = User.new
  end

  def show
    if @user
      @microposts = @user.microposts.page(params[:page]).per_page(
        Settings.per_page.micropost
      ).order_creat_at_desc
    else
      flash[:danger] = t "user_nil"
      redirect_to root_url
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t "user_mailer.account_activation.check_mail"
      redirect_to root_url
    else
      flash.now[:danger] = t "signup_failed"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t "updated"
      redirect_to @user
    else
      flash.now[:danger] = t "update_failed"
      render :edit
    end
  end

  def destroy
    if User.find_by(id: params[:id]).destroy
      flash[:success] = t "user_deleted"
    else
      flash[:danger] = t "user_delete_error"
    end
    redirect_to users_url
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "user_nil"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit(
      :name, :email, :password, :password_confirmation
    )
  end

  def correct_user
    return if current_user? @user

    flash[:danger] = t "login_another"
    redirect_to login_url
  end

  def check_permission
    redirect_to root_url unless current_user.admin?
  end
end
