class AuthController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def create
    # byebug
    @user = User.find_by(username: user_login_params[:username_or_email])
    if !@user
      @user = User.find_by(email: user_login_params[:username_or_email])
    end
    # byebug
    if @user && @user.authenticate(user_login_params[:password])
      token = encode_token({user_id: @user.id})
      render json: { 
        user: UserSerializer.new(@user),
        jwt: token#,
        # categories: @user.days.last.categories,
        # choices: @user.days.last.choices.map do |choice|
        #   new_choice = choice
        #   new_choice.food = choice.food
        #   new_choice
        # end,
        # days: @user.days,
        # goal: @user.days.last.goal,
        # goals: @user.goals
        }, status: :accepted
    else
      # puts @user.errors.full_messages
      render json: { message: 'Invalid username or password' }, status: :unauthorized
    end
  end

  def reauth
    # byebug
    token = encode_token({user_id: current_user.id})
    render json: { user: UserSerializer.new(current_user), jwt: token }, status: :accepted
    # else
    #   puts @user.errors.full_messages
    #   render json: { message: 'Invalid username or password' }, status: :unauthorized
    # end
  end

  private

  def user_login_params
    params.require(:user).permit(:username, :email, :password, :username_or_email)
  end

end
