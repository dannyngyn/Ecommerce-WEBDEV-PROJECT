class CheckoutController < ApplicationController
  def create
    if cart.nil?
      redirect_to root_path
      return
    end

    if Province.find_by(name: params[:province]).nil?
      redirect_to checkout_show_path
      return
    end

    @province = Province.find_by(name: params[:province])
    total_fish_cost = cart.sum { |fish| fish.fish_cost }

    @session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      success_url: checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: checkout_cancel_url,
      mode: "payment",
      line_items: cart.map do |fish|
        {
          quantity: 1,
          price_data: {
            unit_amount: (fish.fish_cost * 100).to_i,
            currency: "cad",
            product_data: {
              name: fish.fish_name
            }
          }
        }
      end +
      (@province.gst > 0 && @province.gst ? [
        quantity: 1,
        price_data: {
          unit_amount: (total_fish_cost * @province.gst).to_i,
          currency: "cad",
          product_data: {
            name: "GST",
            description: "Goods and Services Tax"
          }
        }
      ] : []) +
      (@province.pst > 0 && @province.pst ? [
        quantity: 1,
        price_data: {
          unit_amount: (total_fish_cost * @province.pst).to_i,
          currency: "cad",
          product_data: {
            name: "PST",
            description: "Provincial Sales Tax"
          }
        }
      ] : []) +
      (@province.hst > 0 && @province.hst ? [
        quantity: 1,
        price_data: {
          unit_amount: (total_fish_cost * @province.hst).to_i,
          currency: "cad",
          product_data: {
            name: "HST",
            description: "Harmonized Sales Tax"
          }
        }
      ] : [])
    )

    # respond_to do  |format|
    #   format.js
    # end

    redirect_to @session.url, allow_other_host: true

  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
    @fishes = []

    cart.each do |fish|
      @fishes.append(fish.id)
    end



    #this will be temp, 61 user id is me.
    @user = User.find(61);

    @order = user.orders.create(:user_id, user,
                                :total_cost, fishes)

    cart.each do |fish|
      @fish_order = user.fish_orders.create(:user, user_id,
                                            :fish_id, fishes)
    end

  end

  def cancel

  end
end
