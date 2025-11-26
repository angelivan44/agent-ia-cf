class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :last_name
      t.date :birth_date
      t.string :national_id
      t.string :email

      t.timestamps
    end

    add_index :users, :national_id, unique: true
    add_index :users, :email, unique: true
  end
end
