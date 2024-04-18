class RaisedTypeController < ApplicationController
  def index
    @raised_type = RaisedType.all
  end

  def show
    @raised_type = RaisedType.find(params[:id])
  end
end
