class Post < ActiveRecord::Base
  attr_accessible :msg, :user_id, :parent_id, :dir
  belongs_to :parent, class_name: "Post"
end
