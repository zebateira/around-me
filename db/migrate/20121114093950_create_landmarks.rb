class CreateLandmarks < ActiveRecord::Migration
  def change
    create_table :landmarks do |t|
      t.string :name
      t.bool :is_published
      t.string :website
      t.string :username
      t.text :description
      t.text :about
      t.string :location_street
      t.string :location_city
      t.string :location_country
      t.string :location_zip
      t.float :location_latitude
      t.float :location_longitude
      t.text :public_transit
      t.string :phone
      t.integer :checkins
      t.integer :were_here_count
      t.integer :talking_about_count
      t.string :category
      t.text :general_info
      t.string :id
      t.string :link
      t.integer :likes

      t.timestamps
    end
  end
end
