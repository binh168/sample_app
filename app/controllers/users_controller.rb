class UsersController < ApplicationController
  before_action :load_user, only: %i(show)

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in @user
      flash[:success] = t(".success")
      redirect_to @user
    else
      flash.now[:danger] = t(".error")
      render :new
    end
  end

  def show; end

  private

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end

  def load_user
    @user = User.find_by id: params[:id]
  end
end
