class CreateInsuranceRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :insurance_requests do |t|
      t.string :email
      t.string :full_name
      t.string :national_id
      t.string :vehicle_plate_number
      t.date :birth_date

      t.timestamps
    end

    add_index :insurance_requests, :email, unique: true
    add_index :insurance_requests, :national_id, unique: true
  end
end
