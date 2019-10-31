class UsersController < ApplicationController
  before_action :load_user, only: %i(show destroy)
  before_action :logged_in_user, only: %i(index edit update)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)
  def index
    @users = User.order_user.order_user.page(params[:page]).per Settings.user_per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t".info"
      redirect_to root_path
    else
      flash.now[:danger] = t(".error")
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t(".success")
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @destroy_user = @user.destroy

    if @destroy_user.destroyed?
      flash[:success] = t".danger"
      redirect_to users_url
    else
      flash[:error] = t".error"
      redirect_to users_url
    end
  end

  private

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end

  def load_user
    @user = User.find_by id: params[:id]
    return  if @user
    flash[:danger] = t".not_found_user"
    redirect_to root_url
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash.now[:danger] = t(".danger_loggin")
    redirect_to login_url
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
