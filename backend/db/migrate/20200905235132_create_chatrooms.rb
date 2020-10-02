class CreateChatrooms < ActiveRecord::Migration[6.0]
  def change
    create_table :chatrooms do |t|
      t.string :name
      t.integer :room_code
      t.string :description
      t.integer :user_id
      t.boolean :private, default: false, allow_null: false

      t.timestamps
    end
  end
end
