# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :city, :address, :postal_code, :province_id)
  end
end
