class FishController < ApplicationController
  def index
    if params[:search]
      @search = params[:search]
      @search_id = params[:search_id]
      @fish = Fish.search_by(@search,@search_id)
                  .page(params[:page])
                  .per(25)
      @water = Water.all
    else
      @fish = Fish.all
                    .page(params[:page])
                    .per(25)
      @water = Water.all
    end
  end
  def show
    @fish = Fish.find(params[:id])
  end
end
