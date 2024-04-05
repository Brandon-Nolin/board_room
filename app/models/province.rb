class Province < ApplicationRecord
  has_many :users
  has_many :orders

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "name", "gst", "hst", "pst", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["users"]
  end
end
