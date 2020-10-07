class UserApiAuthentication < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :authentication_token, :string
    add_index :users, :authentication_token, unique: true
    #Ex:- add_index("admin_users", "username")
  end

  def def down 
    remove_column :users, :authentication_token
  end
end
