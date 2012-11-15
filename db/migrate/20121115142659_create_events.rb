class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text :description
      t.string :end_time
      t.boolean :is_date_only
      t.string :id
      t.string :location
      t.string :name
      t.string :owner_name
      t.string :owner_category
      t.string :owner_id
      t.string :privacy
      t.string :start_time
      t.string :timezone
      t.string :updated_time
      t.string :venue_id
      t.float :venue_latitude
      t.float :venue_longitude

      t.timestamps
    end
  end
end
