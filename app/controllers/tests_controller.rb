require 'rest-client'
class TestsController < ApplicationController
  skip_before_action :authorized

  def index
    redirect_to index
  end

end
