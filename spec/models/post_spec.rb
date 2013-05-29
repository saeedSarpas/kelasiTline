require "spec_helper"

describe Post do
	
	it "Should have a parent" do
		p = Post.new parent_id: Post.create.id
		p.parent.should be_an_instance_of Post
	end
end