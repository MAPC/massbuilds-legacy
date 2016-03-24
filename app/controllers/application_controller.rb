class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def authenticate_user!(options = {})
    if user_signed_in?
      super
    else
      redirect_to '/users/sign_in'
    end
  end

  alias_method :devise_current_user, :current_user

  def current_user
    UserPresenter.new(devise_current_user || User.null)
  end

end
