class AddCodeToInsuranceRequest < ActiveRecord::Migration[8.0]
  def change
    add_column :insurance_requests, :code, :string
    add_index :insurance_requests, :code, unique: true
  end
end
