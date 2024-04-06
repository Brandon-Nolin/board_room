ActiveAdmin.register Province do
  permit_params :name, :gst, :pst, :hst
  remove_filter :orders
end
