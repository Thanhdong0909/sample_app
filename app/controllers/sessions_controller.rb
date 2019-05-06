class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      if user.activated?
        login_success user
      else
        flash[:warning] = t ".active_messages"
        redirect_to root_path
      end
    else
      flash.now[:danger] = t ".login_fail"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def login_success user
    log_in user
    if params[:session][:remember_me] == Settings._true
      remember user
    else
      forget user
    end
    redirect_back_or user
  end
end
