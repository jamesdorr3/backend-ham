class SaveAllController < ApplicationController

  def update
    # params[:categories].each do |category| 
    #   cat = Category.find(category[:id])
    #   cat.update(category.permit(:name, :user_id, :index, :updated_at))
    # end
    if params[:choiceFoods]
      params[:choiceFoods].each do |choiceFood| 
        choice = Choice.find(choiceFood[:choice][:id])
        choice.update(choiceFood.require(:choice).permit(:food_id, :measure_id, :day_id, :amount, :category_id, :index))
      end
    end
    if params[:days]
      params[:days].each do |day| 
        d = Day.find(day[:id])
        d.update(day.permit(:name, :goal_id))
      end
    end
    if params[:day]
      day = Day.find(params[:day][:id])
      day[:goal_id] = params[:goal][:id] if params[:goal]
      day[:name] = params[:day][:name]
      day.save
    end
    if params[:goals]
      params[:goals].each do |one_goal| 
        goal = Goal.find(one_goal[:id])
        goal.update(one_goal.permit(:calories, :fat, :carbs, :protein, :name))
      end
      goal = Goal.find(params[:goal][:id])
      goal.update(params[:goal].permit(:calories, :fat, :carbs, :protein, :name))
    end
  end

  private

  def all_params
    params[:categories].each{|x| x.permit(:id, :name, :user_id, :index, :updated_at)}
  end

end
