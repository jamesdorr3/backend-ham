class SaveAllController < ApplicationController

  def update
    
  end

  private

  def all_params
    params.require(:all).permit(:categories, :day, :days, :choiceFoods, :goal, :goals, :user)
  end

end
