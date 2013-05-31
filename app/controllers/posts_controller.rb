class PostsController < ApplicationController

  before_filter :auth

  def index
  	@posts = Post.recent_posts.includes(:user, replies: :user)
  end

  def create
    @message = Post.new params[:user_params]
    @message.save
    redirect_to root_path
  end

  private

  	def auth
       unless logged_in?
      		redirect_to login_path, note: "You need to log in first"
        end
  	end
end
