ActiveAdmin.register Order do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :total_cost, :user_id, :payment_status, :payment_id

  form do |f|
    f.inputs do
      f.input :user, as: :select, collection: User.pluck(:first_name, :id)
      f.input :total_cost
      f.input :payment_status, as: :select, collection: [["New", "New"], ["Cancelled", "Cancelled"], ["Paid", "Paid"], ["Shipped", "Shipped"]]
    end
    f.actions
  end
  #
  # or
  #
  # permit_params do
  #   permitted = [:total_cost, :user_id, :payment_status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
