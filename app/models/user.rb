class User < ApplicationRecord
  belongs_to :province
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.ransackable_attributes(auth_object = nil)
    ["address", "city", "created_at", "email", "encrypted_password", "id", "id_value", "postal_code", "province_id", "remember_created_at", "reset_password_sent_at", "reset_password_token", "updated_at"]
  end
end
