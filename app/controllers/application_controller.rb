class ApplicationController < ActionController::Base

  before_action :initialize_session
  helper_method :cart

  private
  def initialize_session
    session[:shopping_cart] ||= {}
  end

  def cart
    cart_items = {}
    session[:shopping_cart].each do |id, quantity|
      game = Game.find(id)
      cart_items[game] = quantity
    end
    cart_items
  end
end