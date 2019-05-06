class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  include SessionsHelper

  def logged_in_user
    return if logged_in? # user logged in
    store_location
    flash[:danger] = t ".login_mess"
    redirect_to login_url
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
