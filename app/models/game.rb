class Game < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :order_games
  has_many :orders, through: :order_games
  has_one_attached :image

  validates :name, uniqueness:true
  validates :name, :description, :stock_quantity, :current_price, presence: true
  validates :stock_quantity, :min_players, :max_players, :min_age, :year_published, numericality: { only_integer: true, allow_nil: true }
  validates :current_price, numericality: true
  validates :sale_price, numericality: { allow_nil: true}

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "name", "description", "id", "stock_quantity", "min_players", "max_players", "min_age", "year_published", "current_price", "sale_price", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["categories"]
  end

  private

  def self.ransackable_scopes(auth_object = nil)
    []
  end
end
