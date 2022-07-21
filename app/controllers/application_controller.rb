class ApplicationController < ActionController::Base
  include ApplicationHelper
  before_action :set_locale
  before_action :logged_in

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def logged_in
    unless session[:user_id]
      redirect_to new_auths_path
    end
  end

  def admin_reject
    if !current_user.admin
      redirect_to root_path
    end
  end
end
