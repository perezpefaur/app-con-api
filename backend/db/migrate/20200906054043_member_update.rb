class MemberUpdate < ActiveRecord::Migration[6.0]
  def change
    drop_table :members
    create_table :members do |t|
        t.references :user, index: true, foreign_key: true
        t.references :chatroom, index: true, foreign_key: true
  
        t.timestamps
      end
  end
end
