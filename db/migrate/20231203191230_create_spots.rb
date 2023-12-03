class CreateSpots < ActiveRecord::Migration[7.0]
  def change
    create_table :spots do |t|
      t.string :name
      t.integer :windguru_code
      t.json :report
      t.date :report_last_update

      t.timestamps
    end
  end
end
