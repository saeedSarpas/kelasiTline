class Post < ActiveRecord::Base
  attr_accessible :msg, :user_id, :parent_id, :dir
  belongs_to :parent, class_name: "Post"
  has_many :replies, class_name: "Post", foreign_key: "parent_id",
  	dependent: :destroy
end
