class Category < ApplicationRecord
  has_and_belongs_to_many :games

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "name", "id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["games"]
  end
end
