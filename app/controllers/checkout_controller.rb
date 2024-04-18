class CheckoutController < ApplicationController
  def create
    if cart.nil?
      redirect_to root_path
      return
    end

    if (Province.find_by(name: params[:province]).nil? && !user_login_signed_in?)
      flash[:province_notice] =  "#{params[:province]} does not exist"
    end

    if (UserLogin.find_by(email: params[:email]) && !user_login_signed_in?)
      flash[:email_notice] = "Please login with the registered email, #{params[:email]}"
    end

    if(flash[:email_notice] || flash[:province_notice])
      redirect_to checkout_show_path
      return
    end

    if(user_login_signed_in? && current_user_login.user_id)
      user = User.find(current_user_login.user_id)
      province = Province.find_by(id: user.province_id)
    end

    if((user_login_signed_in? && current_user_login.user_id.nil?) || !user_login_signed_in?)
      province = Province.find_by(name: params[:province])

      user = province.users.find_or_create_by(first_name: params[:first_name],
                                              last_name: params[:last_name],
                                              address: params[:address],
                                              email: params[:email],
                                              province_id: province.id)
    end

    if(user_login_signed_in? && current_user_login.user_id.nil?)
      current_user.update(user_id: user.id)
    end

    total_fish_cost = cart.sum { |fish| fish.fish_cost }

    if(province.pst)
      pst_calculation = total_fish_cost * province.pst
    else
      pst_calculation = 0
    end

    if(province.gst)
      gst_calculation = total_fish_cost * province.gst
    else
      gst_calculation = 0
    end

    if(province.hst)
      hst_calculation = total_fish_cost * province.hst
    else
      hst_calculation = 0
    end

    grand_total = total_fish_cost + hst_calculation/100 + gst_calculation/100 + pst_calculation/100

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
      (province.gst > 0 && province.gst ? [
        quantity: 1,
        price_data: {
          unit_amount: gst_calculation.to_i,
          currency: "cad",
          product_data: {
            name: "GST",
            description: "Goods and Services Tax"
          }
        }
      ] : []) +
      (province.pst > 0 && province.pst ? [
        quantity: 1,
        price_data: {
          unit_amount: pst_calculation.to_i,
          currency: "cad",
          product_data: {
            name: "PST",
            description: "Provincial Sales Tax"
          }
        }
      ] : []) +
      (province.hst > 0 && province.hst ? [
        quantity: 1,
        price_data: {
          unit_amount: hst_calculation.to_i,
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

    if(user && user.valid?)
      order = user.orders.create(user_id: user.id,
                                 total_cost: grand_total.to_i,
                                 payment_status: "New")
      if(order && order.valid?)
        cart.each do |fish|
          @fish = Fish.find(fish.id)
          fish_order = order.fish_orders.create(fish: @fish)
        end
      else
        puts "Order Error"
      end
    else
      puts "User Error"
    end

    flash[:order] = order.id
    redirect_to @session.url, allow_other_host: true

  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)

    if flash[:order]
      order = Order.find(flash[:order])
      order.update(payment_status: 'Paid')
      order.update(payment_id: @session["id"])
    end

    session[:shopping_cart] = []

  end

  def cancel
    if flash[:order]
      order = Order.find(flash[:order])
      order.update(payment_status: 'Cancelled')
    end

    session[:shopping_cart] = []
  end

end
