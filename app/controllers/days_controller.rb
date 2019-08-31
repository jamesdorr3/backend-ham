class DaysController < ApplicationController

  def create
    # byebug
    date = params['date'][0,10].split('/')
    date = date[1] + '/' + date[0] + '/' + date[2]
    day = Day.create(goal: current_user.goals.last, date: date.to_date)
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
    day.destroy
  end

  def copy
    day = Day.find(params[:id])
    newDay = Day.create(goal: day.goal, date: Date.today, name: day.name)
    day.choices.each do |choice|
      newChoice = choice.dup
      newChoice.day = newDay
      newChoice.save
    end
    render json: newDay
  end
  
  private
  
  def day_params
    params.require(:day).permit(:goal_id, :name, :date)
  end

end
