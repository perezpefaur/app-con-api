# app/controllers/v1/custom_devise/sessions_controller.rb
module V1
  module CustomDevise
    class SessionsController < Devise::SessionsController
    
    respond_to :json

      acts_as_token_authentication_handler_for User

      before_action :reset_session

      skip_before_action :verify_authenticity_token
      # skip_before_action :authenticate_entity_from_token!, only: [:create]
      #skip_before_action :authenticate_entity!, only: [:create]
      before_action :set_current_user, only: [:destroy]

      # POST /users/sign_in
      def create
        allow_params_authentication!
    
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource)
        

        reset_token resource
        render json: resource
        #render file: 'v1/custom_devise/sessions/create'
      end


      # DELETE /users/sign_out
      def destroy
        if not current_user
          render json: {msg: "Invalid Credentials", status: "Invalid"}
          return
        end

        warden.authenticate!

        reset_token current_user

        render json: {msg: "Sesión cerrada correctamente", status: "OK"}
      end

      def 

      private

      def set_current_user
        token = nil
        if request.headers.include? "X-User-Token"
          token = request.headers["X-User-Token"]
        elsif params.include? "v1_user"
          params.fetch(:v1_user).permit([:email, :authentication_token])
          if params[:v1_user].include? "authentication_token"
            token = params[:v1_user][:authentication_token]
          end
        end
        if token
          @current_user = User.where({authentication_token: token}).first
        end
      end

      def sign_in_params
        params.fetch(:user).permit([:password, :email])
      end

      def reset_token(resource)
        resource.authentication_token = nil
        resource.save!
      end
    end
  end
end