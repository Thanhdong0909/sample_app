class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      login_success user
      redirect_back_or user
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
    params[:session][:remember_me] = if Settings._true
                                       remember user
                                     else
                                       forget user
                                     end
  end
end
