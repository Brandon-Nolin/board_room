class GamesController < ApplicationController
  def index
    if params.key?(:on_sale)
      @games = Game.where.not(sale_price: nil)
    elsif params.key?(:recently_added)
      @games = Game.where("created_at >= ?", 3.days.ago)
    else
      @games = Game.all
    end
  end

  def show
    @game = Game.find(params[:id])
  end
end
