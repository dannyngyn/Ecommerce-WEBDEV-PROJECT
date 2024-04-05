class FishController < ApplicationController
  def index
    @fish = Fish.all
    @water = Water.all
                  .page(params[:page])
                  .per(1)
  end
  def show
    @fish = Fish.find(params[:id])
  end
end
