class GoalsController < ApplicationController

  def update
    goal = Goal.find(params[:id])
    goal.update(goals_params)
    render json: goal
  end

  def create
    goal = Goal.create(goals_params)
    render json: goal
  end

  def destroy
    goal = Goal.find(params[:id])
    # byebug
    if goal.days.length == 0
      goal.destroy
    end
  end

  private

  def goals_params
    params.require(:goal).permit(:id, :user_id, :calories, :fat, :carbs, :protein, :name)
  end

end
