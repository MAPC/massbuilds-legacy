class UsersController < ApplicationController
  def show
    @user = UserPresenter.new(User.find(params[:id]))
  end

  def edit

  end

  private
    def user_params
      params.require(:user).permit(:name, :email)
    end
end
