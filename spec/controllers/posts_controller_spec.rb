require 'spec_helper'

describe PostsController do

	context 'logged in' do

		before { session['user'] = mock_model(User) }
		context 'index action' do

			it "Should return success on GET 'index'" do
				get 'index'
				response.should be_success
			end

			it "Should populate @posts with recent posts" do
				p = Post.create
				get 'index'
				assigns(:posts).last.should == p
			end

      it "Should set @user with current user" do
        get 'index'
        expect(assigns :user).to eq session['user']
      end
		end
	end

	context 'logged out' do

		it "Should redirect to login" do
			get 'index'
			response.should redirect_to login_path
		end
	end
end
