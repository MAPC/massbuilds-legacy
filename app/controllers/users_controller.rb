class UsersController < ApplicationController
  def show
    @user = UserPresenter.new(User.find(params[:id]))
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :first_name, :last_name)
  end
end
