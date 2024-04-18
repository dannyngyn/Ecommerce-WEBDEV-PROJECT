class OrderController < ApplicationController
  def index
    return unless user_login_signed_in?

    @orders = Order.where(user_id: current_user_login.user_id)
  end
end
