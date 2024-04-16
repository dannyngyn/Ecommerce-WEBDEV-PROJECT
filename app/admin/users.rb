ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
    permit_params :first_name, :last_name, :province_id, :address

    filter :first_name
    filter :last_name
    filter :address



  #
  # or
  #
  # permit_params do
  #   permitted = [:first_name, :last_name, :province_id, :address]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
