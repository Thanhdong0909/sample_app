class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".email_success"
      redirect_to root_path
    else
      flash[:danger] = t ".email_error"
      render :new
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t(".email_empty"))
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = t ".has_been_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user
    flash[:danger] = t ".error_mess"
    redirect_to root_path
  end

  def valid_user
    return if @user&.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to root_path
  end

  # Checks expiration of reset token.
  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t ".password_expired"
    redirect_to new_password_reset_url
  end
end
