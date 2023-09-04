class ApplicationController < ActionController::Base
  def authenticate_user!
    redirect_to login_path unless valid_cookie_exists
  end
 
  private
  
  def valid_cookie_exists
    if valid_shop_session
      set_current_shop_session
      true 
    else
      false
    end
  end 

  def valid_shop_session
    cookies["shopify_app_session"] && cookies["shopify_app_session"].split("_").first == session[:shopify_store_url]
  end

  def set_current_shop_session
    @current_shop_session ||= cookies["shopify_app_session"]
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
