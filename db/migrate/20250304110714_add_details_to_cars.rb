class AddDetailsToCars < ActiveRecord::Migration[7.1]
  def change
    add_column :cars, :phase, :string
    add_column :cars, :description, :text
    add_column :cars, :images, :string
    add_column :cars, :year, :integer
    add_column :cars, :km, :integer
    add_column :cars, :price, :decimal
    add_column :cars, :location, :string

    add_reference :cars, :user, index: true, foreign_key: true
  end
end
