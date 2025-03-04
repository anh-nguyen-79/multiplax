class CreateCars < ActiveRecord::Migration[7.1]
  def change
    create_table :cars do |t|
      t.string :desc
      t.string :img

      t.timestamps
    end
  end
end
