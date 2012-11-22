class SlugIds < ActiveRecord::Migration
  def change
	add_column :landmarks, :slug, :string
	add_index :landmarks, :slug, unique: true
  end

end
