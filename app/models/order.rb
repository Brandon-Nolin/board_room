class Order < ApplicationRecord
  belongs_to :province
  belongs_to :user
  has_many :order_games
  has_many :games, through: :order_games

  def self.ransackable_attributes(auth_object = nil)
    ["address", "city", "created_at", "gst", "hst", "id", "id_value", "postal_code", "province_id", "pst", "status", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["games", "order_games", "province"]
  end
end
