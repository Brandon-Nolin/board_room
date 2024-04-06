# app/admin/order.rb
ActiveAdmin.register Order do
  permit_params :province_id, :city, :address, :postal_code, :status, :gst, :pst, :hst
  remove_filter :user

  actions :all, except: [:new, :create]

  form do |f|
    f.semantic_errors # Display errors at the top of the form
    f.inputs "Order Details" do
      f.input :user, label: 'User Name', as: :string, input_html: { value: f.object.user ? "#{f.object.user.first_name} #{f.object.user.last_name}" : '', disabled: true }
      f.input :user, label: 'User Email', as: :string, input_html: { value: f.object.user ? f.object.user.email : '', disabled: true }
      f.input :province
      f.input :city
      f.input :address
      f.input :postal_code
      f.input :gst
      f.input :pst
      f.input :hst
      f.input :status
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :total_cost do |order|
      total_cost = order.order_games.sum { |order_game| order_game.price * order_game.quantity }
      total_tax = (order.hst || 0) + (order.gst || 0) + (order.pst || 0)
      total_cost_with_tax = total_cost + (total_cost * total_tax)
      number_to_currency(total_cost_with_tax)
    end
    column :province
    column :city
    column :address
    column :postal_code
    column :status
    actions
  end

  show do
    attributes_table do
      row :id
      row :user do |order|
        "#{order.user.first_name} #{order.user.last_name}" # Assuming there's a name attribute for users
      end
      row :user_email do |order|
        order.user.email # Assuming there's an email attribute for users
      end
      row :province
      row :city
      row :address
      row :postal_code
      row :gst
      row :pst
      row :hst
      row :total_cost do |order|
        total_cost = order.order_games.sum { |order_game| order_game.price * order_game.quantity }
        total_tax = (order.hst || 0) + (order.gst || 0) + (order.pst || 0)
        total_cost_with_tax = total_cost + (total_cost * total_tax)
        number_to_currency(total_cost_with_tax)
      end
      row :status
    end

    panel "Order Games" do
      table_for order.order_games do
        column "Game" do |order_game|
          order_game.game.name
        end
        column "Quantity", :quantity
        column "Price", :price
      end
    end
  end
end
