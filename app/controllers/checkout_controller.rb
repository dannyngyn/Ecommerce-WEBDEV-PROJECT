class CheckoutController < ApplicationController
  def create
    redirect_to root_path and return if cart.nil?

    if (params[:first_name].blank? ||
       params[:last_name].blank? ||
       params[:address].blank? ||
       params[:email].blank? ||
       params[:province].blank?) && !user_login_signed_in?

      flash[:null_notice] = "PLEASE ENTER DATA IN ALL FIELDS"
      redirect_to checkout_show_path
      return
    end

    if Province.find_by(name: params[:province]).nil? && !user_login_signed_in?
      flash[:province_notice] = "#{params[:province]} DOES NOT EXIST"
    end

    if UserLogin.find_by(email: params[:email]) && !user_login_signed_in?
      flash[:email_notice] = "PLEASE LOGIN W/ THE REGISTERED EMAIL: #{params[:email]}"
    end

    if flash[:email_notice] || flash[:province_notice]
      redirect_to checkout_show_path
      return
    end

    if user_login_signed_in? && !current_user_login.user_id.nil?
      user = User.find(current_user_login.user_id)
      province = Province.find_by(id: user.province_id)
    end

    if (user_login_signed_in? && current_user_login.user_id.nil?) || !user_login_signed_in?
      province = Province.find_by(name: params[:province])

      user = province.users.find_or_create_by(first_name:  params[:first_name],
                                              last_name:   params[:last_name],
                                              address:     params[:address],
                                              email:       params[:email],
                                              province_id: province.id)
    end

    if user_login_signed_in? && current_user_login.user_id.nil?
      current_user_login.update(user_id: user.id)
    end

    total_fish_cost = cart.sum(&:fish_cost)

    pst_calculation = if province.pst
                        total_fish_cost * province.pst
                      else
                        0
                      end

    gst_calculation = if province.gst
                        total_fish_cost * province.gst
                      else
                        0
                      end

    hst_calculation = if province.hst
                        total_fish_cost * province.hst
                      else
                        0
                      end

    grand_total = total_fish_cost + hst_calculation / 100 + gst_calculation / 100 + pst_calculation / 100
    puts hst_calculation
    puts gst_calculation
    puts pst_calculation
    puts total_fish_cost

    @session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      success_url:          "#{checkout_success_url}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url:           checkout_cancel_url,
      mode:                 "payment",
      line_items:           cart.map do |fish|
        {
          quantity:   1,
          price_data: {
            unit_amount:  (fish.fish_cost * 100).to_i,
            currency:     "cad",
            product_data: {
              name: fish.fish_name
            }
          }
        }
      end +
      (if province.gst.positive? && province.gst
         [
           quantity:   1,
           price_data: {
             unit_amount:  gst_calculation.to_i,
             currency:     "cad",
             product_data: {
               name:        "GST",
               description: "Goods and Services Tax"
             }
           }
         ]
       else
         []
       end) +
      (if province.pst.positive? && province.pst
         [
           quantity:   1,
           price_data: {
             unit_amount:  pst_calculation.to_i,
             currency:     "cad",
             product_data: {
               name:        "PST",
               description: "Provincial Sales Tax"
             }
           }
         ]
       else
         []
       end) +
      (if province.hst.positive? && province.hst
         [
           quantity:   1,
           price_data: {
             unit_amount:  hst_calculation.to_i,
             currency:     "cad",
             product_data: {
               name:        "HST",
               description: "Harmonized Sales Tax"
             }
           }
         ]
       else
         []
       end)
    )

    # respond_to do  |format|
    #   format.js
    # end

    if user&.valid?
      puts grand_total
      order = user.orders.create(user_id:        user.id,
                                 total_cost:     grand_total.to_f.round(2),
                                 gst:     (gst_calculation/100).to_f.round(2),
                                 pst:     (pst_calculation/100).to_f.round(2),
                                 hst:     (hst_calculation/100).to_f.round(2),
                                 sub_total:     (total_fish_cost/100).to_f.round(2),
                                 payment_status: "New")
      if order&.valid?
        cart.each do |fish|
          @fish = Fish.find(fish.id)
          order.fish_orders.create(fish: @fish)
          flash[:order] = order.id
        end
      else
        puts "Order Error"
      end
    else
      puts "User Error"
    end

    redirect_to @session.url, allow_other_host: true
  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)

    if flash[:order]
      order = Order.find(flash[:order])
      order.update(payment_status: "Paid")
      order.update(payment_id: @session["id"])
    else
      puts "Error With Order"
    end

    session[:shopping_cart] = []
  end

  def cancel
    if flash[:order]
      order = Order.find(flash[:order])
      order.update(payment_status: "Cancelled")
    else
      puts "Error With Order"
    end

    session[:shopping_cart] = []
  end
end
