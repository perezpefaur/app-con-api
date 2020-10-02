class CreateMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :members do |t|
      t.references :users, index: true, foreign_key: true
      t.references :chatrooms, index: true, foreign_key: true

      t.timestamps
    end
  end
end
