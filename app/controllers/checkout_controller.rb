class CheckoutController < ApplicationController
 
  def create
    # establish a connection with Stripe and redirect the user to the payment screen
    @games = Game.find(session[:shopping_cart].keys)

    line_items = []

    session[:shopping_cart].each do |game_id, quantity|
      game = Game.find(game_id)
      line_items.append(
        {
          quantity: quantity,
          price_data: {
            unit_amount: (game.current_price * 100).to_i,
            currency: "cad",
              product_data: {
                name: game.name,
                description: game.description,
              }
          }
        }
      )
    end

    line_items.append(
      {
          quantity: 1,
          price_data: {
            currency: "cad",
            unit_amount: (@games[0].current_price * 100 * 0.05).to_i,
            product_data: {
              name: "GST",
              description: "Goods and Services Tax",
            }
          }
        }
        
    )
    line_items.append(
      {
        quantity: 1,
        price_data: {
          currency: "cad",
          unit_amount: (@games[0].current_price * 100 * 0.07).to_i,
          product_data: {
            name: "PST",
            description: "Provincial Sales Tax",
          }
          }
        }
    )
 
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
    puts "Cancelled"
  end
end