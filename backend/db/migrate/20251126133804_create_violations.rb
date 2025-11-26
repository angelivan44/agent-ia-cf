class CreateViolations < ActiveRecord::Migration[8.0]
  def change
    create_table :violations do |t|
      t.timestamps
      t.string :national_id
      t.integer :infractions
    end
    
  end
end
