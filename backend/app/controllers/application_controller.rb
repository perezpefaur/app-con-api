class ApplicationController < ActionController::Base
  acts_as_token_authentication_handler_for User, fallback_to_devise: false
  protect_from_forgery with: :null_session
  def after_sign_out_path_for(*)
    new_user_session_path
  end
end
