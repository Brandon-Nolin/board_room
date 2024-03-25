class Game < ApplicationRecord
  has_and_belongs_to_many :categories

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "name", "description", "id", "stock_quantity", "min_players", "max_players", "min_age", "current_price", "sale_price", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["categories"]
  end
end
