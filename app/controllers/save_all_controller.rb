class SaveAllController < ApplicationController

  def update
    params[:categories].each do |category| 
      cat = Category.find(category[:id])
      cat.update(category.permit(:name, :user_id, :index, :updated_at))
    end
    params[:choiceFoods].each do |choiceFood| 
      choice = Choice.find(choiceFood[:choice][:id])
      choice.update(choiceFood.require(:choice).permit(:food_id, :nix_id, :nix_name, :day_id, :amount, :measure, :category_id, :index))
    end
    # byebug
    # params[:days].each do |category| 
    #   cat = Category.find(category.id)
    #   cat.update(x.permit(:id, :name, :user_id, :index, :updated_at))
    # end
    # params[:day].each do |category| 
    #   cat = Category.find(category.id)
    #   cat.update(x.permit(:id, :name, :user_id, :index, :updated_at))
    # end
    # params[:goals].each do |category| 
    #   cat = Category.find(category.id)
    #   cat.update(x.permit(:id, :name, :user_id, :index, :updated_at))
    # end
    # params[:goal].each do |category| 
    #   cat = Category.find(category.id)
    #   cat.update(x.permit(:id, :name, :user_id, :index, :updated_at))
    # end
    # params[:user].each do |category| 
    #   cat = Category.find(category.id)
    #   cat.update(x.permit(:id, :name, :user_id, :index, :updated_at))
    # end
    # params[:user].each do |category| 
    #   cat = Category.find(category.id)
    #   cat.update(x.permit(:id, :name, :user_id, :index, :updated_at))
    # end
  end

  private

  def all_params
    params[:categories].each{|x| x.permit(:id, :name, :user_id, :index, :updated_at)}
  end

end
