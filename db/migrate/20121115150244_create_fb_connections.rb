class CreateFbConnections < ActiveRecord::Migration
  def change
    create_table :fb_connections do |t|

      t.timestamps
    end
  end
end
