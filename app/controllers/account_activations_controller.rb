class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user&.authenticated?(:activation, params[:id]) && !user.activated?
      active_account user
    else
      flash[:danger] = t ".invalid_active"
      redirect_to root_path
    end
  end

  private

  def active_account
    user.activate
    log_in user
    flash[:success] = t ".accoutn_active"
    redirect_to user
  end
end
