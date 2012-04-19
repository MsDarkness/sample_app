class AddPublicprofileToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :publicprofile, :boolean, :default => true
  end

  def self.down
    remove_column :users, :publicprofile
  end
end
