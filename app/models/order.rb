class Order < ApplicationRecord
  belongs_to :province
  belongs_to :user
  has_many :order_games
  has_many :games, through: :order_games

  validates :status, :address, :city, :postal_code, :province_id, presence: true
  validates :hst, :gst, :pst, numericality: { allow_nil: true}

  def self.ransackable_attributes(auth_object = nil)
    ["address", "city", "created_at", "gst", "hst", "id", "id_value", "postal_code", "province_id", "pst", "status", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["games", "order_games", "province"]
  end
end
