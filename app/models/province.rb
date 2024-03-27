class Province < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "name", "gst", "hst", "pst", "updated_at"]
  end
end
