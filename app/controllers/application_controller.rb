class ApplicationController < ActionController::API

  before_action :authorized
  # before_action :current_user

  def encode_token(payload)
    JWT.encode(payload, Rails.application.credentials.jwt[:secret])
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, Rails.application.credentials.jwt[:secret], true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def current_user
    # @@user = nil
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
    # else
    #   @@user = nil
    end
    @user
  end

  def logged_in?
    !!current_user
  end

  def authorized
    # byebug
    # true
    render json: { message: 'Please log in' }, status: :unauthrozed unless logged_in?
  end

end
