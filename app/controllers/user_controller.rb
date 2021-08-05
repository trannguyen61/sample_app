class UserController < ApplicationController
  before_action :load_user, except: %i(index new create)
  before_action :logged_in_user, only: %i(index edit update)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.all.page params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "check_email"
      redirect_to root_url
    else
      flash[:error] = t "fail_signup"
      render :new
    end
  end

  def show
    @microposts = @user.microposts.recent_posts.page params[:page]
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "profile_updated"
      redirect_to @user
    else
      flash[:danger] = t "fail_updated"
      render :edit
    end
  end

  def destroy
    if current_user != @user && @user.destroy
      flash[:success] = t "success_deleted"
    else
      flash[:danger] = t "fail_deleted"
    end
    redirect_to user_url
  end

  private

  def user_params
    params.require(:user).permit User::PERMITTED_FIELDS
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "not_found"
    redirect_to root_path
  end
end
