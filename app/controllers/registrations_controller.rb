class RegistrationsController < Devise::RegistrationsController

  private

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email,
      :password, :password_confirmation)
  end

  def account_params
    params.require(:user).permit(:first_name, :last_name, :email,
      :password, :password_confirmation, :current_password,
      :mail_frequency)
  end

  def after_update_path_for(resource)
    user_path(resource)
  end
end
