class CheckoutController < ApplicationController
 
  def create
    # establish a connection with Stripe and redirect the user to the payment screen
    @games = Game.find(session[:shopping_cart].keys)

    line_items = []
    subtotal = 0

    session[:shopping_cart].each do |game_id, quantity|
      game = Game.find(game_id)
      price = !game.sale_price.nil? ? game.sale_price : game.current_price
      subtotal += price * quantity
      
      line_items.append(
        {
          quantity: quantity,
          price_data: {
            unit_amount: (price * 100).to_i,
            currency: "cad",
              product_data: {
                name: game.name,
                description: game.description,
              }
          }
        }
      )
    end

    user_province = current_user.province

    if !user_province.gst.nil?
      line_items.append(
      {
          quantity: 1,
          price_data: {
            currency: "cad",
            unit_amount: (subtotal * 100 * user_province.gst).to_i,
            product_data: {
              name: "GST",
              description: "Goods and Services Tax",
            }
          }
        }
        
    )
    end

    if !user_province.pst.nil?
      line_items.append(
      {
        quantity: 1,
        price_data: {
          currency: "cad",
          unit_amount: (subtotal * 100 * user_province.pst).to_i,
          product_data: {
            name: "PST",
            description: "Provincial Sales Tax",
          }
          }
        }
    )
    end

    if !user_province.hst.nil?
      line_items.append(
        {
          quantity: 1,
          price_data: {
            currency: "cad",
            unit_amount: (subtotal * 100 * user_province.hst).to_i,
            product_data: {
              name: "HST",
              description: "Harmonized Sales Tax",
            }
            }
          }
      )
    end
 
    @session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      success_url: checkout_success_url,
      cancel_url: checkout_cancel_url,
      customer_email: current_user.email,
      mode: "payment",
      line_items: line_items
    )

    redirect_to @session.url, allow_other_host: true
  end
 
  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
    puts @payment_intentS
  end
 
  def cancel
    redirect_to cart_index_path
  end
end