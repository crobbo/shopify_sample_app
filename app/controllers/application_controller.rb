class ApplicationController < ActionController::Base
  before_action :authenitcate_user!

  def authenitcate_user!
    if !valid_cookie_exists
      redirect_to login_path unless request.path == "/login"
    end
  end
 
  def valid_cookie_exists
    return true if cookies["shopify_app_session"]

    false
  end
end
