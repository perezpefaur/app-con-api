# app/controllers/v1/rooms_controller.rb
module V1
  class RoomsController < BaseController

    respond_to :json

    before_action :reset_session

    skip_before_action :verify_authenticity_token

    before_action :set_current_user, only: [:get_my_rooms, :create]

    before_action :get_create_params, only: [:create]
    before_action :get_my_rooms, only: [:index, :my_rooms]
    before_action :set_join_room, only: [:join_room]
    before_action :set_room, only: [:update, :show, :destroy]

    def index
        av_rooms = Chatroom.where({private: false}).to_a
        @rooms = @my_rooms + av_rooms.difference(@my_rooms.to_a)
        @r_id = get_room_id()
    end

    def my_rooms
        @rooms = @my_rooms
        @r_id = get_room_id()
    end

    def join_room
        if @room
            if Member.create({user_id: current_user.id, chatroom_id: @room.id})
                msg = Message.create({user_id: 0, chatroom_id: @room.id, system: true, body: "@#{current_user.nickname} se ha unido al chat!"})
                date = msg.created_at
                ActionCable.server.broadcast(
                    "messages_#{@room.id}",
                    server: true,
                    data: {body: msg.body, created_at: [date.day, date.month, date.year, date.hour, date.min]}
                  )
                redirect_to show_room_path(@room)
            else
                session[:alert] = "No se ha podido ingresar a la sala"
            redirect_to rooms_index_path
            end
        else
            session[:alert] = "No se ha podido encontrar la sala"
            redirect_to rooms_index_path
        end
    end

    def show
        if @room and Member.find_by({user_id: current_user.id, chatroom_id: @room.id})
            @messages = Message.where({chatroom_id: @room.id})
            render "show"
        else
            session[:alert] = "No se ha podido acceder a la sala."
            redirect_to rooms_index_path
        end
    end

    def destroy
        if @room
            if @room.destroy()
                session[:notice] = "Sala cerrada correctamente."
                redirect_to my_rooms_path
            else
                session[:alert] = "Ha ocurrido un error al cerrar la sala."
                redirect_to my_rooms_path
            end
        else
            session[:alert] = "No se ha podido cerrar la sala."
            redirect_to my_rooms_path
        end
    end

    def create
        puts 'Enter Create'
        if not current_user
            render json: {error: "Invalid Credentials"}
            return
        end
        @new_room_attr[:user_id] = current_user.id
        @room = Chatroom.create(@new_room_attr)
        Member.create({user_id: current_user.id, chatroom_id: @room.id})

        render json: @room
    end

    protected

    def set_current_user
        puts 'Here in Set Current User'
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
          @current_user = User.where({authentication_token: token}).first
        end
      end

    def set_room
        @room = Chatroom.find_by({id: params[:chatroom]})
    end

    def set_join_room
        @room = Chatroom.find_by({room_code: params.require(:chatroom).permit(:chatroom_code)[:chatroom_code]})
    end

    def get_my_rooms
        if not current_user
            render json: {error: "Invalid Credentials"}
            return
        end
        puts @current_user.authentication_token
        @my_rooms = Chatroom.includes(:chatroom).where(members: {user_id: current_user.id})
    end

    def get_create_params
        if not current_user
            render json: {error: "Invalid Credentials"}
            return
        end
        @room_id = get_room_id()
        @new_room_attr = params.require(:chatroom).permit(:name, :private, :description, room_code: @room_id)
    end

    def get_room_id
        @r_id = rand(1000..9999)
        while Chatroom.find_by({room_code: @r_id})
            @r_id = rand(1000..9999)
        end
        return @r_id
    end

  end
end
