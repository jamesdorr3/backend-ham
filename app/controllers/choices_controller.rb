class ChoicesController < ApplicationController

  def index
    render :json => Choice.all
  end

  def update
    choice = Choice.find(params[:id])
    choice.update(choice_params)
    choice.save
    # byebug
  end

  def destroy
    choice = Choice.find(params[:id])
    choice.destroy
  end

  private

  def choice_params
    params.require(:choice).permit(:amount, :measure)
  end

end
