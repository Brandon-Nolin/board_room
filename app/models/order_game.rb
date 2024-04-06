class OrderGame < ApplicationRecord
  belongs_to :order
  belongs_to :game

  validates :quantity, :price, presence: true
  validates :quantity, numericality: { only_integer: true }
  validates :price, numericality: true


  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "game_id", "id", "id_value", "order_id", "price", "quantity", "updated_at"]
  end
end
