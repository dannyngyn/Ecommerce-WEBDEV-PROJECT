ActiveAdmin.register Fish do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #

  permit_params :fish_name, :stock, :size, :fish_cost, :water_id, :image, :raised_type

  index do
    selectable_column
    id_column
    column :fish_name
    column :stock
    column :size
    column :fish_cost
    column "Raised Type" do |fish|
      fish.raised_type.raised_type
    end
    column "Water Type" do |fish|
      fish.water.water_type
    end
    actions
  end

  filter :fish_name
  filter :stock
  filter :size
  filter :fish_cost
  filter :raised_type_raised_type, as: :select, collection: -> {RaisedType.pluck(:raised_type)}
  filter :water_water_type, as: :select, collection: -> {Water.pluck(:water_type)}

  form do |f|
    f.inputs do
      f.input :raised_type, as: :select, collection: RaisedType.pluck(:raised_type, :id)
      f.input :water, as: :select, collection: Water.pluck(:water_type, :id)
      f.input :fish_name
      f.input :stock
      f.input :size
      f.input :fish_cost
    end
    f.semantic_errors
    f.inputs do
      f.input :image, as: :file, hint: f.object.image.present? ? image_tag(f.object.image) : ""
    end
    f.actions
  end

  #
  # or
  #
  # permit_params do
  #   permitted = [:fish_name, :stock, :size, :fish_cost, :water_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
