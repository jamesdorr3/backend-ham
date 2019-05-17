class UsersController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def index
    render :json => User.all
  end

  def update
    puts 'USER RRRRR______________________'
    puts @user
    user = User.find(params[:id])
    user.update(update_user_params)
    user.save
    puts user.errors.full_messages
    render :json => user
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      @token = encode_token({ user_id: @user.id })
      render json: { user: UserSerializer.new(@user), jwt: @token }, status: :created
    else
      render json: { error: 'failed to create user' }, status: :not_acceptable
    end
  end

  private

  def user_params
    params.require(:user).permit(:id, :username, :email, :calories, :fat, :carbs, :protein)
  end

  def update_user_params
    params.require(:user).permit(:calories, :fat, :carbs, :protein)
  end

end
