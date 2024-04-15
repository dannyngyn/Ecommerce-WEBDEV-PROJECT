class CheckoutController < ApplicationController
  def create
    if cart.nil?
      redirect_to root_path
      return
    end

    @session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      success_url: checkout_success_url,
      cancel_url: checkout_cancel_url,
      mode: "payment",
      line_items: cart.map do |fish|
        {
          quantity: 1, #TEMP
          price_data: {
            unit_amount: (fish.fish_cost * 100).to_i,
            currency: "cad",
            product_data: {
              name: fish.fish_name,
            }
          }
        }
      end
      #add tax
    )

    # respond_to do  |format|
    #   format.js
    # end

    redirect_to @session.url, allow_other_host: true

  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
  end

  def cancel

  end
end
