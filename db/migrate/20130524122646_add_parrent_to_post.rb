class AddParrentToPost < ActiveRecord::Migration
  def change
  	add_column :posts, :parent, :integer, :default => 0
  end
end