Rails.application.routes.draw do
  devise_for :users, :skip => [:sessions, :passwords, :registrations]
  scope path: '/api' do
    api_version(module: "V1", path: { value: "v1" }, defaults: { format: 'json' }) do
      devise_for :users, controllers: {
        registrations: 'v1/custom_devise/registrations',
        sessions: 'v1/custom_devise/sessions',
      }

      get 'chatrooms', to: "rooms#index", as: :rooms_index #Check
      post 'chatrooms', to: "rooms#create", as: :new_room #Check
      get 'chatrooms/my-rooms', to: "rooms#my_rooms", as: :my_rooms #Check
      post 'chatrooms/join', to: "rooms#join_room", as: :join_room #Midle Check (Missing Action Cable)
      get 'chatrooms/:id', to: "rooms#show", as: :show_room #Check
      delete 'chatrooms/:id', to: "rooms#destroy", as: :delete_room #Check

      get 'chatrooms/:id/messages', to: "messages#index", as: :messages_room
      post 'chatrooms/:id/messages', to: "messages#create", as: :create_message_room
    end
  end
  # get 'home/index'
  # devise_for :user, controllers: {
  #   sessions: 'users/sessions',
  #   registrations: 'users/registrations'
  # }
  # get 'chatrooms/', to: "rooms#index", as: :rooms_index
  # post 'chatrooms', to: "rooms#create", as: :new_room
  # get 'chatrooms/my-rooms', to: "rooms#my_rooms", as: :my_rooms
  # post 'chatrooms/join', to: "rooms#join_room", as: :join_room
  # get 'chatrooms/:chatroom', to: "rooms#show", as: :show_room
  # delete 'chatrooms/:chatroom', to: "rooms#destroy", as: :delete_room

  # post 'messages/new', to: "messages#create", as: :new_message

  mount ActionCable.server, at: '/cable'

  root 'home#index'
end
