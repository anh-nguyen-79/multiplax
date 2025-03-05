class CreateRentals < ActiveRecord::Migration[7.1]
  def change
    create_table :rentals do |t|
      t.references :user, null: false, foreign_key: true
      t.references :car, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.string :status,  null: false, default: "confirmed"
      t.integer :price, null: false

      t.timestamps
    end
  end
end
