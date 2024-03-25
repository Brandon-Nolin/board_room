ActiveAdmin.register Category do
  remove_filter :games
  permit_params :name
end
