class Order < ApplicationRecord
  belongs_to :province
  has_many :games, through: :order_games
end
