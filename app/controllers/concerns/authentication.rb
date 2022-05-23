module Authentication
  extend ActiveSupport::Concern
  included do


    private

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]).decorate if session[:user_id].present?
    end

    def user_sign_in?
      current_user.present?
    end

    def sign_in(user)
      session[:user_id] = user.id
    end

    def sing_out
      session.delete(:user_id)
    end

    def require_no_auth
      return unless user_sign_in?
      flash[:warning] = "You are already sign in!"
      redirect_to root_path
    end

    def require_auth
      return if user_sign_in?
      flash[:warning] = "You are not sign in!"
      redirect_to root_path
    end

    helper_method :current_user, :user_sign_in?
  end
end