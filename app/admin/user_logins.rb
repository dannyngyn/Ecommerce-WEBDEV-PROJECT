ActiveAdmin.register UserLogin do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
   permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :user_id, :remember_created_at

   filter :email

   form do |f|
    f.inputs do
      f.input :user, as: :select, collection: User.pluck(:first_name, :id)
      f.input :email
    end
      f.actions
  end

  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
