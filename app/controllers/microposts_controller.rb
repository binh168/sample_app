class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: %i(destroy)

  def create
    @micropost = current_user.microposts.build micropost_params

    if @micropost.save
      flash[:success] = t ".micropost_created"
      redirect_to root_path
    else
      @feed_items = []
      render "static_pages/home"
    end
  end
    
  def destroy
    @micropost.destroy

    if @micropost.destroyed?
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".danger"
    end
    redirect_to request.referrer || root_path
  end

  private

  def micropost_params
    params.require(:micropost).permit Micropost::PARAMS_MICROPOST
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_path unless @micropost
  end
end
