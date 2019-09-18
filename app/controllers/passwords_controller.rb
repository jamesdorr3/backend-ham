
class PasswordsController < ApplicationController
  skip_before_action :authorized

  def forgot
    if params[:email].blank?
      return render json: {error: 'Email not present'}
    end

    @user = User.find_by(email: params[:email])
    # byebug
    if @user.present?
      @user.generate_password_token! ###
      # @user.url_email = url_encode(@user.email)
      UserMailer.password_reset(@user).deliver_now
      render json: {error: "Email sent to #{@user.email}"}, status: :ok
    else
      render json: {error: 'Email not found'}, status: :not_found
    end
  end

  def reset
    token = params[:user][:token].to_s
    email = params[:user][:email].to_s
    
    @user = User.find_by(reset_password_token: token, email: email)
    
    if @user.present? && @user.password_token_valid? ###
      if @user.reset_password!(params[:user][:password])
        render json: {error: 'Password reset successful!'}, status: :ok
      else
        render json: {error: @user.errors.full_messages}, status: :unprocessable_entity
      end
    elsif User.find_by(email: email)
      render json: {error: '34'}, status: :precondition_failed
    elsif User.find_by(reset_password_token: token)
      render json: {eror: '36'}, status: :not_found
    else
      render json: {error: 'Link invalid or expired'}, status: :bad_request
    end
  end

end
