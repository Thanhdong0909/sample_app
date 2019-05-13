class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :load_user, except: %i(new index create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def show; end

  def index
    @users = User.paginate page: params[:page]
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".wellcome"
      redirect_to @user
    else
      render :new
    end
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".edit.update"
      redirect_to @user
    else
      render :edit
    end
  end

  def edit; end

  def destroy
    if @user.destroy
      flash[:success] = t ".edit.delete_success"
      redirect_to users_path
    else
      flash[:danger] = t ".edit.error_invalid"
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email,
      :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in? # user logged in
    store_location
    flash[:danger] = t".login_mess"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_path unless @user == current_user
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] =  t ".edit.error_invalid"
    redirect_to root_path
  end
end
