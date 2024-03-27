ActiveAdmin.register Game do
  permit_params :name, :description, :stock_quantity, :min_players, :max_players, :current_price, :year_published, :sale_price, :category_ids
  remove_filter :image_attachment, :image_blob

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :description
      f.input :stock_quantity
      f.input :min_age
      f.input :min_players
      f.input :max_players
      f.input :year_published
      f.input :current_price
      f.input :sale_price
      f.input :categories, as: :check_boxes, collection: Category.all.map { |category| [category.name, category.id] }
      f.input :image, as: :file, input_html: { accept: 'image/*' }
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
    column :year_published
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
      row :year_published
      row :current_price
      row :sale_price
      row "Categories" do |game|
        game.categories.map(&:name).join(", ")
      end
      row :image do |game|
        if game.image.attached?
          image_tag rails_blob_path(game.image, only_path: true), style: "max-width: 500px; max-height: 500px;"
        else
          "No Image Available"
        end
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
      if params[:game][:image].present?
        @game.image.attach(params[:game][:image])
      end
      @game.categories = Category.find(params[:game][:category_ids].reject(&:empty?))
      @game.update(permitted_params[:game].except(:image))
      redirect_to admin_games_path
    end
  end
end