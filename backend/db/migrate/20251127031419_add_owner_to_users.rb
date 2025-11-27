class AddOwnerToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :owner, :boolean, default: true
  end
end
