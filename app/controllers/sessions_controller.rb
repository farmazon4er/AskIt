# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :require_no_auth, only: %i[new create]
  before_action :require_auth, only: :destroy

  def new; end

  def create
    # render plain: params.to_yaml
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      sign_in(user)
      remember(user) if params[:remember_me] == '1'
      flash[:success] = "Welcome back, #{current_user.name_or_email}"
      redirect_to root_path
    else
      flash[:warning] = 'incorrect email and/or password'
      render :new
    end
  end

  def destroy
    sing_out
    flash[:success] = 'See you later'
    redirect_to root_path
  end
end
