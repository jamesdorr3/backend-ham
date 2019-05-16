class UsersController < ApplicationController

  def index
    render :json => User.all
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    user.save
    render :json => user
  end

  private

  def user_params
    params.permit(:calories, :fat, :carbs, :protein)
  end

end
