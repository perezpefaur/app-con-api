# app/controllers/v1/messages_controller.rb
module V1
  class MessagesController < BaseController

    respond_to :json

    before_action :reset_session

    skip_before_action :verify_authenticity_token

    before_action :set_current_user, only: [:index, :create]

    before_action :set_room, only: [:create, :index]

    def index
      if not current_user
        response = {:status => 401, error: "Invalid Credentials"}
      elsif @room and Member.find_by({user_id: current_user.id, chatroom_id: @room.id})
        db_messages = Message.where({chatroom_id: @room.id})
        @messages = []
        db_messages.each do |m|
          @messages << {body: m.body, user: m.username, date: m.created_at.strftime("%d %m %y %H %M").split(" "), isMe: m.user_id == current_user.id, system: m.system}
        end
        
        response = {messages: @messages, status: 200}
      else
        response = {:status => 400, error: "Can't access to chatroom messages"}
      end

      render json: response, status: response[:status]
    end

    def create
      if not current_user
        response = {:status => 401, error: "Invalid Credentials"}
      elsif not @room
        response = {status: 400, error: "Invalid room ID" }
      else
        @msg_params = get_create_params
        @msg_params[:user_id] = current_user.id
        @msg_params[:username] = current_user.nickname
        @msg_params[:chatroom_id] = @room.id
        
        message = Message.new(@msg_params)

        @msg_params = @msg_params.to_h
        @msg_params.delete(:user_id)
        @msg_params.delete(:chatroom_id)
        @msg_params.delete(:created_at)
        if message.save
            date = message.created_at.strftime("%d %m %y %H %M").split(" ")
            @msg_params[:date] = date
            response = {message: @msg_params, status: 200}

            # ActionCable.server.broadcast(
            #     "messages_#{room_id}",
            #     server: false,
            #     data: @msg_params
            # )
        else
            response = {error: "Can't send the message", status: 400}
        end
      end
      
      render json: response, status: response[:status]

  end

    protected

    def set_current_user
        puts "Enter Set Current User"
        token = nil
        if request.headers.include? "X-User-Token"
          token = request.headers["X-User-Token"]
        elsif params.include? "authentication_token"
          token = params[:authentication_token]
        end
        puts "============"
        puts token
        if token
          @current_user = User.where({authentication_token: token}).first
        end
      end

    def set_room
        @room = Chatroom.find_by({id: params[:id]})
    end


    def get_create_params
        params.require(:message).permit(:body)
    end

  end
end
