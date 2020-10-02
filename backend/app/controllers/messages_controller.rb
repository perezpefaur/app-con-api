class MessagesController < ApplicationController
    before_action :get_params
    before_action :authenticate_user!

    def create
        command = "none"
        if @msg_params[:body].include? "/"
            command = command_hanlder(@msg_params[:body].split(" "), @msg_params[:chatroom_id])
        end
        if command == "none"
            @msg_params[:user_id] = current_user.id
            @msg_params[:username] = current_user.nickname
            
            message = Message.new(@msg_params)

            @msg_params = @msg_params.to_h
            @msg_params.delete(:user_id)
            room_id = @msg_params[:chatroom_id]
            @msg_params.delete(:chatroom_id)
            response = {msg: @msg_params}
            if message.save
                response[:status] = 200
                date = message.created_at.strftime("%d %m %y %H %M").split(" ")
                @msg_params[:created_at] = date

                ActionCable.server.broadcast(
                    "messages_#{room_id}",
                    server: false,
                    data: @msg_params
                )
            else
                response[:status] = 400
                @msg_params.delete(:user_id)
            end
        elsif command == "pass"
            response = {:status => 200}
        else
            response = {:status => 400, :msg => {body: "Comando inválido, ingresa /help para obtener ayuda."}}
        end
        respond_to do |format|
            format.json { render json: response }
        end

    end

    protected

    def get_params
        @msg_params = params.require(:message).permit(:chatroom_id, :body)
    end

    def command_hanlder(command, room_id)
        puts command.length
        commands = {"/ban" =>  "/ban @usuario -> Permite echar a un usuario de la sala", "/add" => "/add @usuario -> Permite agregar a un usuario a la sala."}
        if command[0] == "/help"
            resp = "<ul><li>/help -> Muestra los comandos disponibles</li>"
            commands.each do |c, ar|
                resp += "<li>" + ar + "</li>"
            end
            resp += "</ul>"
            date = DateTime.current.strftime("%d %m %y %H %M").split(" ")
            ActionCable.server.broadcast(
                "messages_#{room_id}",
                server: true,
                data: {body: resp, created_at: date}
              )

            return "pass"
        elsif command.length == 2
            res = false
            if command[0] == "/ban"
                res = ban_user(command[1], room_id)
            elsif command[0] == "/add"
                res = add_user(command[1], room_id)
            end
            if res
                ActionCable.server.broadcast(
                    "messages_#{room_id}",
                    server: true,
                    data: res
                  )
                return "pass"
            end
        end
        return "false"
    end

    def ban_user(username, r_id)
        username = username[1..]
        user = User.find_by({nickname: username})
        if user
            is_in = Member.find_by({user_id: user.id, chatroom_id: r_id})
            if is_in
                is_in.destroy()
                msg = Message.create({user_id: 0, chatroom_id: r_id, system: true, body: "@#{username} ha sido eliminado"})
                date = msg.created_at.strftime("%d %m %y %H %M").split(" ")
                return {body: msg.body, created_at: date}
            end
        end
        return false
    end

    def add_user(username, r_id)
        username = username[1..]
        user = User.find_by({nickname: username})
        if user
            is_in = Member.find_by({user_id: user.id, chatroom_id: r_id})
            if not is_in
                Member.create({user_id: user.id, chatroom_id: r_id})
                msg = Message.create({user_id: 0, chatroom_id: r_id, system: true, body: "@#{username} se ha unido al chat!"})
                date = msg.created_at.strftime("%d %m %y %H %M").split(" ")
                
                return {body: msg.body, created_at: date}
            end
        end
        return false
    end
end
