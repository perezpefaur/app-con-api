# app/controllers/v1/rooms_controller.rb
module V1
  class RoomsController < BaseController

    respond_to :json

    before_action :reset_session

    skip_before_action :verify_authenticity_token

    before_action :set_current_user, only: [:index, :create, :show, :destroy, :my_rooms, :join_room]

    before_action :get_create_params, only: [:create]
    before_action :get_my_rooms, only: [:index, :my_rooms]
    before_action :set_join_room, only: [:join_room]
    before_action :set_room, only: [:update, :show, :destroy]

    def index
        av_rooms = Chatroom.where({private: false}).to_a
        @rooms = @my_rooms + av_rooms.difference(@my_rooms.to_a)
        @r_id = get_room_code()
        render json: @rooms
    end

    def my_rooms
        @my_rooms
        render json: @my_rooms
    end

    def join_room
        if @room
            if not Member.find_by({user_id: current_v1_user.id, chatroom_id: @room.id})
                Member.create({user_id: current_v1_user.id, chatroom_id: @room.id})
                msg = Message.create({user_id: 0, chatroom_id: @room.id, system: true, body: "@#{current_v1_user.nickname} se ha unido al chat!"})
                date = msg.created_at
                # ActionCable.server.broadcast(
                #     "messages_#{@room.id}",
                #     server: true,
                #     data: {body: msg.body, created_at: [date.day, date.month, date.year, date.hour, date.min]}
                #   )
                db_messages = Message.where({chatroom_id: @room.id})
                @messages = []
                db_messages.each do |m|
                  @messages << {body: m.body, user: m.username, date: m.created_at.strftime("%d %m %y %H %M").split(" "), isMe: m.user_id == current_v1_user.id, system: m.system}
                end
                render json: {room: @room, messages: @messages}
            else
                render json: {status: "No se ha podido ingresar a la sala"}
            end
        else
            render json: {status: "No se ha podido acceder a la sala."}
        end
    end

    def show
        if @room and Member.find_by({user_id: current_v1_user.id, chatroom_id: @room.id})
            db_messages = Message.where({chatroom_id: @room.id})
                @messages = []
                db_messages.each do |m|
                  @messages << {body: m.body, user: m.username, date: m.created_at.strftime("%d %m %y %H %M").split(" "), isMe: m.user_id == current_v1_user.id, system: m.system}
                end
                render json: {room: @room, messages: @messages}
        else
            render json: {status: "No se ha podido acceder a la sala."}
        end
    end

    def destroy
        if @room
            if @room.destroy()
                render json: {status: "Sala cerrada correctamente."}
            else
                render json: {status: "Ha ocurrido un error al cerrar la sala."}
            end
        else
            render json: {status: "No se ha podido encontrar la sala."}
        end
    end

    def create
        if not current_v1_user
            render json: {error: "Invalid Credentials"}
            return
        end
        @new_room_attr[:user_id] = current_v1_user.id
        @room = Chatroom.create(@new_room_attr)
        Member.create({user_id: current_v1_user.id, chatroom_id: @room.id})

        render json: @room
    end

    protected

    def set_current_user
        puts "Enter Set Current User"
        token = nil
        if request.headers.include? "X-User-Token"
          token = request.headers["X-User-Token"]
        elsif params.include? "chatroom"
            if params[:chatroom].include? "authentication_token"
                token = params[:chatroom][:authentication_token]
                puts token
            end
        end
        if token
          @current_v1_user = User.where({authentication_token: token}).first
        end
      end

    def set_room
        if not current_v1_user
            render json: {error: "Invalid Credentials"}
            return
        end
        @room = Chatroom.find_by({id: params[:id]})
    end

    def set_join_room
        if not current_v1_user
            render json: {error: "Invalid Credentials"}
            return
        end
        @room = Chatroom.find_by({room_code: params.require(:chatroom).permit(:room_code)[:room_code]})
    end

    def get_my_rooms
        if not current_v1_user
            render json: {error: "Invalid Credentials"}
            return
        end
        @my_rooms = Chatroom.includes(:members).where(members: {user_id: current_v1_user.id})
    end

    def get_create_params
        if not current_v1_user
            render json: {error: "Invalid Credentials"}
            return
        end
        @room_code = get_room_code()
        @new_room_attr = params.require(:chatroom).permit(:name, :private, :description)
        @new_room_attr["room_code"] = @room_code
    end

    def get_room_code
        @r_code = rand(1000..9999)
        while Chatroom.find_by({room_code: @r_code})
            @r_code = rand(1000..9999)
        end
        return @r_code
    end

  end
end
