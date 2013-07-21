require 'spec_helper'

describe ApplicationController do

	it "should say if we aren't logged in" do
		subject.should_not be_logged_in
	end

	it "should say if we logged in" do
		subject.current_user = User.first
		subject.should be_logged_in
	end
end
