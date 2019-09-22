class DaysController < ApplicationController

  def create
    # byebug
    date = params['date'][0,10].split('/')
    date = date[1] + '/' + date[0] + '/' + date[2]
    goal = current_user.goals.last
    day = Day.create(goal: goal, date: date.to_date)
    day.generate_categories
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
    # byebug
    # day.choices.destroy_all
    # day.categories.destroy_all
    day.destroy
  end

  def copy
    day = Day.find(params[:id])
    new_day = Day.create(goal: day.goal, date: Date.today, name: day.name)
    day.categories.each do |category|
      category.dup_with_choices(new_day)
      # new_cat = cat.dup
      # new_cat.day = new_day
      # new_cat.save
    end
    # day.choices.each do |choice|
    #   new_choice = choice.dup
    #   new_choice.day = new_day
    #   new_choice.save
    # end
    render json: new_day
  end
  
  private
  
  def day_params
    params.require(:day).permit(:goal_id, :name, :date)
  end

end
