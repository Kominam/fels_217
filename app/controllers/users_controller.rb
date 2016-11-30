class UsersController < ApplicationController

  def index
    @users = User.all.paginate page: params[:page]
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
    if @user.save
      log_in @user
      flash[:success] = t ".signup_success"
      redirect_to @user
    else
      flash.now[:danger] = t ".signup_fail"
      render :new
    end
  end

  def edit
    @user = User.find_by id: params[:id]
    if @user.nil?
      render file: "public/404.html", layout: false
    end
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

  private
  def user_params
    params.require(:user).permit :user_name, :email, :password,
      :password_confirmation
  end
end
