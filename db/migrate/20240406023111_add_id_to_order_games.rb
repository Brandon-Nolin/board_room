class AddIdToOrderGames < ActiveRecord::Migration[6.0]
  def change
    add_column :order_games, :id, :primary_key
  end
end
