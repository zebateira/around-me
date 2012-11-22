class RenameIds < ActiveRecord::Migration
  def change
    add_column :landmarks, :fb_id, :string
    add_column :events, :fb_id, :string
    add_column :events, :landmark_id, :integer
  end
end
