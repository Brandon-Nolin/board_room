ActiveAdmin.register Game do
  permit_params :name, :description, :stock_quantity, :min_players, :max_players, :current_price, :sale_price, :category_ids, :new_category_name

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :description
      f.input :stock_quantity
      f.input :min_age
      f.input :min_players
      f.input :max_players
      f.input :current_price
      f.input :sale_price
      f.input :categories, as: :check_boxes, collection: Category.all.map { |category| [category.name, category.id] }
    end
    f.actions
  end

  index do
    selectable_column
    column :name
    column "Description" do |game|
      truncate(game.description, length: 50) # Adjust the length as needed
    end
    column :stock_quantity
    column :min_age
    column :min_players
    column :max_players
    column :current_price
    column :sale_price
    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :stock_quantity
      row :min_age
      row :min_players
      row :max_players
      row :current_price
      row :sale_price
      row "Categories" do |game|
        game.categories.map(&:name).join(", ")
      end
    end
  end

  controller do
    def create
      @game = Game.new(permitted_params[:game])
      @game.categories << Category.find(params[:game][:category_ids].reject(&:empty?))
      @game.save
      redirect_to admin_games_path
    end

    def update
      @game = Game.find(params[:id])
      @game.categories = Category.find(params[:game][:category_ids].reject(&:empty?))
      @game.update(permitted_params[:game])
      redirect_to admin_games_path
    end
  end
end