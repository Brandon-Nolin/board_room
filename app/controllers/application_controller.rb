class ApplicationController < ActionController::Base

  before_action :initialize_session
  helper_method :cart

  private
  def initialize_session
    session[:shopping_cart] ||= {}
  end

  def cart
    ids = session[:shopping_cart].keys
    puts Game.find(ids)
  end
end