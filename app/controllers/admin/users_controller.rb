class Admin::UsersController < ApplicationController
  before_action :require_auth

  def index
    respond_to do |format|
      format.html do @pagy, @users = pagy User.order(created_at: :desc)
      end

      format.zip { respond_with_zip_users }

    end
  end

  def create
    if params[:archive].present?
      UserBulkService.call(params[:archive])
      flash[:success] = "User imported"
    end

    redirect_to admin_users_path
  end

  private

  def respond_with_zip_users
    compressed_file = Zip::OutputStream.write_buffer do |zos|
      User.order(created_at: :desc).each do |user|
        zos.put_next_entry "user_#{user.id}.xlsx"
        zos.print render_to_string(
                    layout: false, handlers: [:axlsx], formats: [:xlsx], template: 'admin/users/users',
                    locals: {user: user} )
      end
    end
    compressed_file.rewind
    send_data(compressed_file.read, filename: 'users.zip')
  end
end