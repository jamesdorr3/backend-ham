class ChoicesController < ApplicationController

  def index
    render :json => Choice.all
  end

end
