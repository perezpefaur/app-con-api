class Chatroom < ApplicationRecord
    has_many :members, dependent: :delete_all
    has_many :users, through: :members
    has_many :messages, dependent: :destroy
end
