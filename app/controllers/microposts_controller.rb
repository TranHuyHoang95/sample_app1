class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :build_micropost, only: :create
  before_action :correct_user, :feed_items, only: :destroy

  def create
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = t "micropost.create_success"
      redirect_to root_url
    else
      flash.now[:danger] = t "micropost.create_failed"
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "micropost.delete_success"
    else
      flash[:danger] = t "micropost.delete_failed"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    return if (@micropost = current_user.microposts.find_by id: params[:id])

    redirect_to root_url
  end

  def build_micropost
    @micropost = current_user.microposts.build(micropost_params)
  end

  def feed_items
    @feed_items = current_user.feed.page(params[:page]).order_creat_at_desc
  end
end
