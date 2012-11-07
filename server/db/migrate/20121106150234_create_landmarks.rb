class CreateLandmarks < ActiveRecord::Migration
  def change
    create_table :landmarks do |t|
      t.string :fb_username

      t.timestamps
    end
  end
end
