# app/controllers/v1/messages_controller.rb
module V1
  class MessagesController < BaseController

    respond_to :json

    before_action :reset_session

    skip_before_action :verify_authenticity_token

    before_action :set_current_user, only: [:index, :create]

    before_action :set_room, only: [:create, :index]

    def index
      if not current_v1_user
        response = {:status => 401, error: "Invalid Credentials"}
      elsif @room and Member.find_by({user_id: current_v1_user.id, chatroom_id: @room.id})
        db_messages = Message.where({chatroom_id: @room.id})
        @messages = []
        db_messages.each do |m|
          @messages << {body: m.body, user: m.username, date: m.created_at.strftime("%d %m %y %H %M").split(" "), isMe: m.user_id == current_v1_user.id, system: m.system}
        end
        
        response = {messages: @messages, status: 200}
      else
        response = {:status => 400, error: "Can't access to chatroom messages"}
      end

      render json: response, status: response[:status]
    end

    def create
      if not current_v1_user
        response = {:status => 401, error: "Invalid Credentials"}
      elsif not @room
        response = {status: 400, error: "Invalid room ID" }
      elsif Member.find_by({user_id: current_v1_user.id, chatroom_id: @room.id})
        @msg_params = get_create_params
        @msg_params[:user_id] = current_v1_user.id
        @msg_params[:username] = current_v1_user.nickname
        @msg_params[:chatroom_id] = @room.id
        
        message = Message.new(@msg_params)

        @msg_params = @msg_params.to_h
        # @msg_params.delete(:user_id)
        @msg_params.delete(:chatroom_id)
        @msg_params.delete(:created_at)
        if message.save
            date = message.created_at.strftime("%d %m %y %H %M").split(" ")
            @msg_params[:date] = date
            response = {message: @msg_params, status: 200}
            ActionCable.server.broadcast(
                "messages_#{@room.id}",
                server: false,
                data: @msg_params
            )

            if @msg_params[:body].include? "@"
              nickname = @msg_params[:body].split("@")[1].split(" ")[0]
              mention = User.where({nickname: nickname}).first
              if mention && Member.find_by({user_id: mention.id, chatroom_id: @room.id})
                notification = {title: "Te han mencionado en la sala #{@room.name}", body: @msg_params[:body]}
                ActionCable.server.broadcast(
                    "notification_user_#{mention.id}",
                    server: false,
                    data: notification
                )
              end
            end
        else
            response = {error: "Can't send the message", status: 400}
        end
      else
        response = {error: "Can't send the message", status: 400}
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
          @current_v1_user = User.where({authentication_token: token}).first
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
