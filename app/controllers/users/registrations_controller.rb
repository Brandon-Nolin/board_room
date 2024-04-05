# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_account_update_params, only: [:update]

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :city, :address, :postal_code, :province_id)
  end

  protected

  def update_resource(resource, params)
    # Require current password if user is trying to change password.
    return super if params["password"].present?

    # Allows user to update registration information without password.
    resource.update_without_password(params.except("current_password"))
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :password_confirmation, :current_password, :first_name, :last_name, :city, :address, :postal_code, :province_id])
  end
end