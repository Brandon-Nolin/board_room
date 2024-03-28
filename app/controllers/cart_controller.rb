class CartController < ApplicationController
  def create
    logger.debug("adding #{params[:id]} to cart.")
    id = params[:id].to_i
    quantity = params[id].to_i

    if session[:shopping_cart][id]
      session[:shopping_cart][id] += quantity
    else
      session[:shopping_cart][id] = quantity
    end

    game = Game.find(id)


    if session[:shopping_cart][id] > game.stock_quantity
      session[:shopping_cart][id] = game.stock_quantity
    end

    flash[:notice] = "#{game.name} added to cart."
    redirect_to "/games"
  end
  def destroy
    id = params[:id].to_i
    session[:shopping_cart].delete(id)

  end
end