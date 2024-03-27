class AddYearPublishedToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :year_published, :integer
  end
end
