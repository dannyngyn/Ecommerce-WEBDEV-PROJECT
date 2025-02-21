class CartController < ApplicationController
  def create
    logger.debug("adding fish_id #{params[:id]} with quantity of #{params[:quantity]} to cart.")
    id = params[:id].to_i

    session[:shopping_cart] << id unless session[:shopping_cart].include?(id)
    fish = Fish.find(id)
    flash[:notice] = "+ #{fish.fish_name} added to cart."
    redirect_to fish_index_path
  end

  def destroy
    id = params[:id].to_i
    session[:shopping_cart].delete(id)
    fish = Fish.find(id)
    flash[:notice] = "- #{fish.fish_name} removed from cart."
    redirect_to cart_index_path
  end
end
