class SaveAllController < ApplicationController

  def update
    # params[:categories].each do |category| 
    #   cat = Category.find(category[:id])
    #   cat.update(category.permit(:name, :user_id, :index, :updated_at))
    # end
    params[:choiceFoods].each do |choiceFood| 
      choice = Choice.find(choiceFood[:choice][:id])
      choice.update(choiceFood.require(:choice).permit(:food_id, :nix_id, :nix_name, :day_id, :amount, :measure, :category_id, :index))
    end
    params[:days].each do |day| 
      d = Day.find(day[:id])
      d.update(day.permit(:name, :goal_id))
    end
    day = Day.find(params[:day][:id])
    day[:goal_id] = params[:goal][:id]
    day[:name] = params[:day][:name]
    day.save
    params[:goals].each do |one_goal| 
      goal = Goal.find(one_goal[:id])
      goal.update(one_goal.permit(:calories, :fat, :carbs, :protein, :name))
    end
    goal = Goal.find(params[:goal][:id])
    goal.update(params[:goal].permit(:calories, :fat, :carbs, :protein, :name))
    # puts current_user[:email]
  end

  private

  def all_params
    params[:categories].each{|x| x.permit(:id, :name, :user_id, :index, :updated_at)}
  end

end
