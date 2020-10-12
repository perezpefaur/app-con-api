# app/controllers/v1/custom_devise/registrations_controller.rb
module V1
  module CustomDevise
    class RegistrationsController < Devise::RegistrationsController

      respond_to :json

      before_action :reset_session

      skip_before_action :verify_authenticity_token
      
      acts_as_token_authentication_handler_for User

      #skip_before_action :authenticate_entity_from_token!, only: [:create]
      #skip_before_action :authenticate_entity!, only: [:create]

      #skip_before_action :authenticate_scope!
      append_before_action :authenticate_scope!, only: [:destroy]
      before_action :set_current_user, only: [:update]
      

      # GET /users/sign_up
  

      # POST /users
      def create
        build_resource(sign_up_params)

        if resource.save
          sign_up(resource_name, resource)
          puts resource
          render json: {account: resource}
          # render file: 'v1/custom_devise/registrations/create', status: :created
        else
          clean_up_passwords resource
          resource
          render json: { errors: resource.errors.full_messages }
        end
      end


      # DELETE /users/UUID
      def destroy
        resource.deactivated_at = DateTime.now
        resource.save!
        Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      end

      # PUT /resource
      def update
        if not resource
          render json: {error: "Invalid Credentials"}
          return
        end

        if update_params[:password].present?
          if not update_params[:password_confirmation].present?
            render json: {error: "Password confirmation is not included."}
            return
          end
        end

        if resource.update(update_params)
          render json: {msg: "Success update", account: resource}
        else
          render json: { error: resource.errors.full_messages }
        end

      end

      private

      def set_current_user
        token = nil
        if request.headers.include? "X-User-Token"
          token = request.headers["X-User-Token"]
        elsif params.include? "v1_user"
          if params[:v1_user].include? "authentication_token"
            token = params[:v1_user][:authentication_token]
          end
        end
        if token
          self.resource = User.where({authentication_token: token}).first
        end
      end

      def update_params
        params.fetch(:v1_user).permit([:nickname, :password, :password_confirmation])
      end

      def sign_up_params
        params.fetch(:v1_user).permit([:password, :password_confirmation, :email, :nickname])
      end

    end
  end
end
