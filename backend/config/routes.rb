Rails.application.routes.draw do
  get 'home/index'
  devise_for :user, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get 'chatrooms/', to: "rooms#index", as: :rooms_index
  post 'chatrooms', to: "rooms#create", as: :new_room
  get 'chatrooms/my-rooms', to: "rooms#my_rooms", as: :my_rooms
  post 'chatrooms/join', to: "rooms#join_room", as: :join_room
  get 'chatrooms/:chatroom', to: "rooms#show", as: :show_room
  delete 'chatrooms/:chatroom', to: "rooms#destroy", as: :delete_room

  post 'messages/new', to: "messages#create", as: :new_message

  mount ActionCable.server, at: '/cable'

  root 'rooms#index'
end
