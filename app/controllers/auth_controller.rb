class AuthController < ApplicationController
  skip_before_action :authorized, only: [:create, :edit]

  def create
    @user = User.find_by(username: user_login_params[:username_or_email].downcase)
    # byebug
    if !@user
      @user = User.find_by(email: user_login_params[:username_or_email].downcase)
    end
    # byebug
    if @user && @user.authenticate(user_login_params[:password])# && @user.activated_at
      token = encode_token({user_id: @user.id})
      render json: { 
        user: UserSerializer.new(@user),
        jwt: token
        }, status: :accepted
    # elsif @user && !@user.activated_at
    #   UserMailer.welcome_email(@user).deliver_now
    #   render json: { message: 'A confirmation email has been sent'}, status: :unauthorized
    else
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

  def edit
    # JWT.encode(payload, Rails.application.credentials.jwt[:secret])
    # JWT.decode(token, Rails.application.credentials.jwt[:secret], true, algorithm: 'HS256')
    user = User.find_by(email: params['email'])
    token = params['id']
    # debugger
    if user && user.activation_digest == token
      user.update(activated_at: Time.now)
    end
    redirect_to 'https://jamesdorr3.github.io/ham'
  end

  private

  def user_login_params
    params.require(:user).permit(:username, :email, :password, :username_or_email)
  end

end
