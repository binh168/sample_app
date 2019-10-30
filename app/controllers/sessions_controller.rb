class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user&.authenticate params[:session][:password]
      if user.activated?
        log_in user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_to user
      else
        flash[:warning] = t".messeage"
        redirect_to root_path
      end
    else
      flash.now[:danger] = t".danger"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
