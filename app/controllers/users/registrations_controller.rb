# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def create
    province_id = params[:user].delete(:province) # Extract province ID
    @user = User.new(sign_up_params) # Instantiate a new user with permitted parameters
    @user.province = Province.find(province_id)
  
    if @user.save
      sign_in(@user) # Sign in the user after successful registration
      redirect_to '/'
    else
      render :new
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :city, :address, :postal_code, :province)
  end
end
