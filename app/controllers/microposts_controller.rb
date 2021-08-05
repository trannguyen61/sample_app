class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy
  before_action :create_post, only: :create

  def create
    if @micropost.save
      flash[:success] = t ".create_post"
      redirect_to root_url
    else
      flash[:danger] = t ".fail_post"

      # Home page requires @feed_items
      # while directly rendering doesn't invoke controller method
      @feed_items = User.feed(current_user.id).page params[:page]
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t ".delete_post"
      redirect_to root_url
    else
      flash[:danger] = t ".delete_fail"
      redirect_to request.referer || root_url
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit Micropost::PERMITTED_FIELDS
  end

  def correct_user
    @micropost = current_user.microposts.recent_posts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "not_found"
    redirect_to request.referer || root_url
  end

  def create_post
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params[:micropost][:image]
  end
end
