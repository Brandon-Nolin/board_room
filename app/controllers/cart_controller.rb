class CartController < ApplicationController
  def index
    @cart = cart
    province = Province.find(current_user.province_id)

    @subtotal = 0

    @cart.each do |game, quantity|
      @subtotal += game.current_price * quantity
    end

    total_tax_rate = province.hst.to_d + province.gst.to_d + province.pst.to_d
    @tax_total = (@subtotal * total_tax_rate).round(2)
    @total = @subtotal + @tax_total
  end
  def create
    logger.debug("adding #{params[:id]} to cart.")
    id = params[:id].to_i
    quantity = params[:quantity].to_i

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

  def increment
    session[:shopping_cart][params[:id]] += 1

    if session[:shopping_cart][params[:id]] >= params[:stock_quantity].to_i
      session[:shopping_cart][params[:id]] = params[:stock_quantity].to_i
    end

    redirect_to cart_index_path
  end

  def decrement
    session[:shopping_cart][params[:id]] -= 1

    if session[:shopping_cart][params[:id]] <= 0
      session[:shopping_cart].delete(params[:id])
    end

    redirect_to cart_index_path
  end
  def destroy
    session[:shopping_cart].delete(params[:id])

    redirect_to cart_index_path
  end
end