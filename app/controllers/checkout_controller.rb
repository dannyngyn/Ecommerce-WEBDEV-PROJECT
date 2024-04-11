class CheckoutController < ApplicationController

  def create
    @fish = Fish.find(params[:fish_id])
    if @product.nil?
      redirect_to root_path
      return
    end

    @session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"]
    )

    #respond_to do |format|
    #  format
    #end

    redirect_to @session.url, allow_other_host: true
  end

  def success

  end

  def cancel

  end
end
