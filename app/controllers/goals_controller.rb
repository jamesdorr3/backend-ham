class GoalsController < ApplicationController

  def update
    goal = Goal.find(params[:id])
    goal.update(goals_params)
    render json: goal
  end

  def create
    goal = Goal.create(goals_params)
    day = Day.find(params[:day_id])
    day.update(goal: goal)
    render json: goal
  end

  def destroy
    goal = Goal.find(params[:id])
    goal.change_days_goals
    goal.delete
  end

  private

  def goals_params
    params.require(:goal).permit(:user_id, :calories, :fat, :carbs, :protein, :name)
  end

end
