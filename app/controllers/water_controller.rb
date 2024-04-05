class WaterController < ApplicationController
  def index
    @water = Water.all
  end

  def show
    @water = Water.find(params[:id])
    @fish = Fish.all
  end
end
