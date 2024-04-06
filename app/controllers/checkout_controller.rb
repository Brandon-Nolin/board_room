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

    @customer = Stripe::Customer.create({
      name: "#{current_user.first_name} #{current_user.last_name}",
      email: current_user.email,
      shipping: {
        name: "#{current_user.first_name} #{current_user.last_name}",
        address: {
          city: current_user.city,
          country: "CA",
          line1: current_user.address,
          state: current_user.province.name,
          postal_code: current_user.postal_code
        }
      }
    })
 
    @session = Stripe::Checkout::Session.create(
      customer: @customer,
      payment_method_types: ["card"],
      success_url: checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: checkout_cancel_url,
      mode: "payment",
      line_items: line_items
    )

    redirect_to @session.url, allow_other_host: true
  end
 
  def success
    puts current_user.inspect
    #Create the order
    order = Order.create(
      user: User.find(current_user.id),
      hst: current_user.province.hst,
      pst: current_user.province.pst,
      gst: current_user.province.gst,
      city: current_user.city,
      address: current_user.address,
      postal_code: current_user.postal_code,
      province: Province.find(current_user.province_id),
      status: "payment received"
    )

    #Create OrderGames
    session[:shopping_cart].each do |game_id, quantity|
      game = Game.find(game_id)
      price = game.sale_price ? game.sale_price : game.current_price

      order_game = OrderGame.create(
        order: order,
        game: game,
        quantity: quantity,
        price: price
      )

      #Clear the cart
      session.delete(:shopping_cart)
    end
  end
 
  def cancel
    redirect_to cart_index_path
  end
end