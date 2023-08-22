class ApplicationController < ActionController::Base
  before_action :authenitcate_user!

  def authenitcate_user!
    if !valid_cookie_exists
      redirect_to login_path unless request.path == "/login"
    end
  end
 
  private
  
  def valid_cookie_exists
    if cookies["shopify_app_session"]
      set_current_shop_session
      true 
    else
      false
    end
  end 

  def set_current_shop_session
    @current_shop_session = cookies["shopify_app_session"]
  end

  def current_shop_session
    @current_shop_session
  end
  helper_method :current_shop_session

  def current_shop
    @current_shop ||= Shop.find_by(store_url: current_shop_session.split("_").first)
  end
  helper_method :current_shop
end
