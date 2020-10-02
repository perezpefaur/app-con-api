class ChatroomUpdate < ActiveRecord::Migration[6.0]
  def change
    remove_column :chatrooms, :room_code
    add_column :chatrooms, :room_code, :integer, unique: true
  end
end
