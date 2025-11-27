class AddCurrenyToVehicle < ActiveRecord::Migration[8.0]
  def change
    add_column :vehicles, :currency, :string
  end
end
