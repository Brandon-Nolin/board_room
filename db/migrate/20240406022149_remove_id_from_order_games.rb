class RemoveIdFromOrderGames < ActiveRecord::Migration[6.0]
  def change
    remove_column :order_games, :id
  end
end
