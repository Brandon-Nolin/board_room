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

  def search
    @search_term = "%#{params[:keywords]}%"

    if params[:category] && params[:category][:name]
      @category = params[:category][:name]
    else
      @category = ""
    end
    puts @category

    if @category.present?
      @games = Game.joins(:categories)
                .where("games.name LIKE ? AND categories.name = ?", @search_term, @category)
                .page(params[:page]).per(20)
    else
      @games = Game.where("name LIKE ?", @search_term)
                .page(params[:page]).per(20)
    end

    render :index
  end
end
