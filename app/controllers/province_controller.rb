class ProvinceController < ApplicationController
  def index
    @provinces = Province.all
  end
end
