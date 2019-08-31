class PasswordsController < ApplicationController
  skip_before_action :authorized, only: [:forgot, :reset, :edit]

  def forgot
    if params[:email].blank?
      return render json: {error: 'Email not present'}
    end

    @user = User.find_by(email: params[:email])
    # byebug
    if @user.present?
      @user.generate_password_token! ###
      UserMailer.password_reset(@user).deliver_now
      render json: {error: 'Password reset email sent'}, status: :ok
    else
      render json: {error: 'Email not found'}, status: :not_found
    end
  end

  def reset
    token = params[:id].to_s
    
    if params[:email].blank?
      return render json: {error: 'Token not present'}
    end

    @user = User.find_by(reset_password_token: token)

    if @user.present? && @user.password_token_valid? ###
      if @user.reset_password!(params[:password])
        render json: {error: 'Password reset successful!'}, status: :ok
      else
        render json: {error: @user.errors.full_messages}, status: :unprocessable_entity
      end
    else
      render json: {error: 'Link invalid or expired'}, status: :not_found
    end
  end

  def edit
    byebug
    token = params[:id].to_s
    
    if params[:email].blank?
      return render json: {error: 'Token not present'}
    end

    @user = User.find_by(reset_password_token: token)

    if @user.present? && @user.password_token_valid? ###
      if @user.reset_password!(params[:password])
        render json: {error: 'Password reset successful!'}, status: :ok
      else
        render json: {error: @user.errors.full_messages}, status: :unprocessable_entity
      end
    else
      render json: {error: 'Link invalid or expired'}, status: :not_found
    end
  end

end
