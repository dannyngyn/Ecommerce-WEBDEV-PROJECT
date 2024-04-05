class WaterController < ApplicationController
  def index
    @water = Water.all
  end

  def show
    @water = Water.find(params[:id])
  end
end
