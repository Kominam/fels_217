class UsersController < ApplicationController
  skip_before_action :logged_in_user, only: [:new, :create]
  before_action :admin_user, only: :destroy

  def index
    @users = User.search_name(params[:q])
      .paginate page: params[:page]
  end

  def show
    @user = User.find_by id: params[:id]
    render_404 if @user.nil?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if current_user.nil?
      if @user.save
        log_in @user
        flash[:success] = t ".signup_success"
        redirect_to @user
      else
        flash.now[:danger] = t ".signup_fail"
        render :new
      end
    else
      flash.now[:danger] = t ".logout"
      render :new
    end
  end

  def edit
    @user = User.find_by id: params[:id]
    render_404 if @user.nil?
  end

  def update
    @user = User.find_by id: params[:id]
    if @user.update_attributes user_params
      flash[:success] = t(".profile")
      redirect_to @user
    else
      render :edit
    end
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t(".please")
      redirect_to login_url
    end
  end

  def destroy
    @user = User.find_by id: params[:id]
    if @user.nil?
      render_404
    else
      @user.destroy
      flash[:success] = t(".success")
      redirect_to users_url
    end
  end

  private
  def user_params
    params.require(:user).permit :user_name, :email, :password,
      :password_confirmation
  end

  def admin_user
    redirect_to root_url unless current_user.is_admin?
  end

end
