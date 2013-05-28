class Post < ActiveRecord::Base
  attr_accessible :msg, :user_id, :parent, :dir
end
