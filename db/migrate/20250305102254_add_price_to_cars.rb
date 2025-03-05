class AddPriceToCars < ActiveRecord::Migration[7.1]
  def change
    add_column :cars, :price, :integer
  end
end
