class ApplicationController < ActionController::Base
  include ErrorHandler
  include Pagy::Backend
  include Authentication

end
