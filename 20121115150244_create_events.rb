class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :id
      t.text :description
      t.string :end_time
      t.boolean :is_date_only
      t.string :location
      t.string :name
      t.string :owner_id
      t.string :owner_name
      t.string :owner_category
      t.string :privacy
      t.string :start_time
      t.string :timezone
      t.string :updated_time
      t.string :landmark_id

      t.timestamps
    end
  end
end
