class GamesController < ApplicationController
  def index
    if params.key?(:on_sale)
      @games = Game.where.not(sale_price: nil).page(params[:page]).per(20)
    elsif params.key?(:recently_added)
      @games = Game.where("created_at >= ?", 3.days.ago).page(params[:page]).per(20)
    else
      @games = Game.all.page(params[:page]).per(20)
    end
  end

  def show
    @game = Game.find(params[:id])
  end
end
