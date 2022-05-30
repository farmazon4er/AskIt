# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern
  included do
    private

    def current_user
      user = session[:user_id].present? ? user_from_session : user_from_token
      return if user.blank?

      @current_user ||= user.decorate
    end

    def user_from_session
      User.find_by(id: session[:user_id])
    end

    def user_from_token
      user = User.find_by(id: cookies.encrypted[:user_id])
      token = cookies.encrypted[:remember_token]

      return unless user&.remember_token_authenticated?(token)

      sign_in(user)
      user
    end

    def user_sign_in?
      current_user.present?
    end

    def sign_in(user)
      session[:user_id] = user.id
    end

    def sing_out
      forget(current_user)
      session.delete(:user_id)
      @current_user = nil
    end

    def remember(user)
      user.remember_me
      cookies.encrypted.permanent[:remember_token] = user.remember_token
      cookies.encrypted.permanent[:user_id] = user.id
    end

    def forget(user)
      user.forget_me
      cookies.delete :user_id
      cookies.delete :remember_token
    end

    def require_no_auth
      return unless user_sign_in?

      flash[:warning] = 'You are already sign in!'
      redirect_to root_path
    end

    def require_auth
      return if user_sign_in?

      flash[:warning] = 'You are not sign in!'
      redirect_to root_path
    end

    helper_method :current_user, :user_sign_in?
  end
end
