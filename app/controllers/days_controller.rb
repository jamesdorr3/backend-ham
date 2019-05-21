class DaysController < ApplicationController

  def create
    # byebug
    day = Day.create(goal: current_user.goals.last)
    render json: day
  end

end
