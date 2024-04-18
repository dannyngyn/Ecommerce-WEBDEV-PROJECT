class FishController < ApplicationController
  def index
    load_fish
    @water = Water.all
  end

  def show
    @fish = Fish.find(params[:id])
  end

  def load_fish
    if params[:search]
      search_fish
    else
      all_fish
    end
  end

  def search_fish
    @search = params[:search]
    @search_id = params[:search_id]
    @fish = Fish.search_by(@search, @search_id).page(params[:page]).per(25)
  end

  def all_fish
    @fish = Fish.all.page(params[:page]).per(25)
  end
end
