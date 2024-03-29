class CheckoutController < ApplicationController
  def index
    @cart = cart
  end
end
