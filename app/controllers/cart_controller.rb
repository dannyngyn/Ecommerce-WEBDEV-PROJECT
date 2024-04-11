class CartController < ApplicationController
  def create
    logger.debug("adding fish_id #{params[:id]} with quantity of #{params[:quantity]} to cart.")
    id = params[:id].to_i
    quantity = params[:quantity].to_i

    session[:shopping_cart] << id unless session[:shopping_cart].include?(id)
    session[:shopping_cart][id] += quantity
    fish = Fish.find(id)
    flash[:notice] = "+ #{fish.fish_name} added to cart."
    redirect_to root_path
  end
  def destroy
    id = params[:id].to_i
    session[:shopping_cart].delete(id)
    fish = Fish.find(id)
    flash[:notice] = "- #{fish.fish_name} removed from cart."
  end
end
