class AddUserAndVehicleToInsuranceRequests < ActiveRecord::Migration[8.0]
  def change
    add_reference :insurance_requests, :user, null: true, foreign_key: { on_delete: :nullify }
    add_reference :insurance_requests, :vehicle, null: true, foreign_key: { on_delete: :nullify }
  end
end
