class UsersController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def index
    render :json => User.all
  end

  def update
    # puts 'USER RRRRR______________________'
    # puts @user
    user = User.find(params[:id])
    user.update(update_user_params)
    user.save
    # puts user.errors.full_messages
    render :json => user
  end

  def create ## problems
    @user = User.create(user_params)
    @user.create_activation_digest
    if @user.valid?
      Category.create(user: @user, name: 'Breakfast')
      Category.create(user: @user, name: 'Lunch')
      Category.create(user: @user, name: 'Snacks')
      Category.create(user: @user, name: 'Dinner')
      goal = Goal.create(user: @user, name: 'Macro Goals', calories: 0, fat: 0, carbs: 0, protein: 0)
      Day.create(goal: goal, date: Date.today)
      @token = encode_token({ user_id: @user.id })
      UserMailer.welcome_email(@user).deliver_now
      render json: { error: "Activation email sent to #{@user.email}"}
      # render json: { user: UserSerializer.new(@user), jwt: @token }, status: :created
    else
      render json: { error: 'Username or Email already in use' }, status: :not_acceptable
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:id, :password, :username, :email, :calories, :fat, :carbs, :protein)
  end

  def update_user_params
    params.require(:user).permit(:calories, :fat, :carbs, :protein)
  end


end
