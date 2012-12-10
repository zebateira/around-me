class RenameIds < ActiveRecord::Migration
  def change
    add_column :landmarks, :fb_id, :string
    add_column :landmarks, :cover_id, :integer
    add_column :landmarks, :cover_source, :string
    add_column :events, :fb_id, :string
    add_column :events, :landmark_id, :integer
    add_column :events, :picture_url, :string
  end
end
