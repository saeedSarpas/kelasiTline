class AddDirToPost < ActiveRecord::Migration
  def change
    add_column :posts, :dir, :integer, :default => 0
  end
end
