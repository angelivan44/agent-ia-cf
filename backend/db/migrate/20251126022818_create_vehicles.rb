class CreateVehicles < ActiveRecord::Migration[8.0]
  def change
    create_table :vehicles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :plate_number
      t.date :year
      t.float :price

      t.timestamps
    end

    add_index :vehicles, :plate_number, unique: true
  end
end
