class AddSportNameToSports < ActiveRecord::Migration[7.0]
  def change
    add_column :sports, :sport_name, :integer
  end
end
