require "spec_helper"

describe Post do
	
	it "Should have a parent" do
		p = Post.new parent_id: Post.create.id
		p.parent.should be_an_instance_of Post
	end

	it "Should have replies" do
		p = Post.create
		Post.create {|q| q.parent_id = p.id }
		p.replies.count.should == 1
	end

	it "Should sort by 'created_at desc' by default" do
		p1 = Post.create {|q| q.id = 1}
		p2 = Post.create {|q| q.id = 2}
		Post.first(2).should == [p2, p1]
	end

	it "Should have recent posts" do
		ps = []
		30.times do |i|
			ps << Post.create
		end
		Post.recent_posts(10).should == ps.last(10).reverse
	end

	it "should have a user" do
		p = Post.create user_id: 1
		p.user.should == User.find(1)
	end
end