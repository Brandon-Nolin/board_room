class HomeController < ApplicationController
  def index
    @all_game_image = Game.all.sample.image
    @all_categories_image = Game.all.sample.image
    @games_on_sale = Game.where.not(sale_price: nil).limit(4)
    @games_created_recently = Game.where("created_at >= ?", 3.days.ago).limit(4)
  end
end
