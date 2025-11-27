class AddModelToVehicle < ActiveRecord::Migration[8.0]
  def change
    add_column :vehicles, :model, :string
  end
end
