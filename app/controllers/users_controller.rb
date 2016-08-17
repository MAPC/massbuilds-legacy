class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:dashboard]
  before_action :get_user
  before_action :assert_correct_user, only: [:dashboard]


  def show
  end

  def dashboard
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :first_name, :last_name)
  end

  def assert_correct_user
    unless User.find(params[:id]) == devise_current_user
      flash[:error] = "You may only view your own dashboard."
      redirect_to request.referrer || dashboard_user_path(devise_current_user)
    end
  end

  def get_user
    @user = UserPresenter.new(User.find(params[:id]))
  end
end
