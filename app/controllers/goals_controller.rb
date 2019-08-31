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
    # goal.days.each do |day|
    #   day.goal = current_user.goals.filter{|x| x.id != goal.id}[0]
    #   day.save
    # end
    goal.destroy
  end

  private

  def goals_params
    params.require(:goal).permit(:user_id, :calories, :fat, :carbs, :protein, :name)
  end

end
