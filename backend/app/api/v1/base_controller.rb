class V1::BaseController < ApplicationController

  protect_from_forgery with: :exception
  
  acts_as_token_authentication_handler_for User, fallback_to_devise: false


  include ApiErrorConcern

  self.responder = ApiResponder


  respond_to :json
end
