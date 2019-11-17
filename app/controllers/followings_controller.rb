class FollowingsController < ApplicationController
  before_action :logged_in_user
  
  def index
    @title = t ".title_following"
    @user = User.find_by id: params[:id]

    if @user
      @users = @user.followers.page(params[:page]).per Settings.user_per_page
    else
      flash[:danger] = t ".danger
    end
    render "users/show_follow"
  end
end
