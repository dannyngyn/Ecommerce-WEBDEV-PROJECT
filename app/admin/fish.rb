ActiveAdmin.register Fish do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #

  permit_params :fish_name, :stock, :size, :fish_cost, :water_id

  #
  # or
  #
  # permit_params do
  #   permitted = [:fish_name, :stock, :size, :fish_cost, :water_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
