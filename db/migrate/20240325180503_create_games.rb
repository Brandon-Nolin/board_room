class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.string :name
      t.string :description
      t.integer :stock_quantity
      t.integer :min_players
      t.integer :max_players
      t.integer :min_age
      t.decimal :current_price
      t.decimal :sale_price

      t.timestamps
    end
  end
end
