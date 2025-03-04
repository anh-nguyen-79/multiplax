class RenommeTableViewsEnuser < ActiveRecord::Migration[7.1]
  def change
    rename_table :views, :users
  end
end
