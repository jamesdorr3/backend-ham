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

  def update
    day = Day.find(params[:id])
    day.update(day_params)
  end

  def destroy
    day = Day.find(params[:id])
    day.choices.each do |choice|
      choice.destroy
    end
    day.destroy
  end
  
  private
  
  def day_params
    params.require(:day).permit(:goal_id, :name)
  end

end
