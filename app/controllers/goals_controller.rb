class GoalsController < ApplicationController

  def update
    goal = Goal.find(params[:id])
    goal.update(goals_params)
    render json: goal
  end

  private

  def goals_params
    params.require(:goal).permit(:id, :user_id, :calories, :fat, :carbs, :protein, :name)
  end

end
