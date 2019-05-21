class DaysController < ApplicationController

  def create
    # byebug
    day = Day.create(goal: current_user.goals.last)
    render json: day
  end

  def show
    day = Day.find(params[:id])
    render json: day
  end

end
