class UpdateMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :system, :boolean, default: false, allow_null: false
  end
end
