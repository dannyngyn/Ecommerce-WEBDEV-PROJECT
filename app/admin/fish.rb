ActiveAdmin.register Fish do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #

  index do
    selectable_column
    id_column
    column :fish_name
    column :stock
    column :size
    column :fish_cost
    column "Water Type" do |fish|
      fish.water.water_type
    end
    actions
  end

  filter :fish_name
  filter :stock
  filter :size
  filter :fish_cost
  filter :water_water_type, as: :select, collection: -> { Water.pluck(:water_type, :id) }

  #
  # or
  #
  # permit_params do
  #   permitted = [:fish_name, :stock, :size, :fish_cost, :water_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
