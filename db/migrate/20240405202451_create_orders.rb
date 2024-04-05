class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.decimal :gst
      t.decimal :pst
      t.decimal :hst
      t.string :status
      t.string :city
      t.string :address
      t.string :postal_code

      t.timestamps
    end
  end
end
