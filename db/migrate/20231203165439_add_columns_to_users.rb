class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :alias, :string
    add_column :users, :phone, :string
  end
end
