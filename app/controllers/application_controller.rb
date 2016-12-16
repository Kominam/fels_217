class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  include SessionsHelper

  before_action :logged_in_user

  def load_all_category
    @categories = Category.all
  end

  private

  def logged_in_user
    unless logged_in?
      flash[:danger] = t "login_confirm"
      redirect_to login_path
    end
  end
end
