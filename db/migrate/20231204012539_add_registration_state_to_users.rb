class AddRegistrationStateToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :registration_state, :string
  end
end
