class PostsController < ApplicationController

  before_filter :auth

  def index
  	@posts = Post.recent_posts.includes(:user, replies: :user)
    @user = session['user']

    ActiveRecord::Base.include_root_in_json = true

    respond_to do |format|
      format.html
      format.json { render json: @allPosts.to_json( except: ["updated_at"]) }
    end
  end

  def create
    @message = Post.new
    @message.user_id   = session['user'].id
    @message.msg       = params[:msg]
    @message.parent_id = params[:parent_id] if params[:parent_id].present?
    @message.dir       = params[:dir]
    @message.save
    redirect_to root_path
  end

  def destroy
    @post = Post.where("id = #{params[:id]} or parent = #{params[:id]}")
    @post.update_all(:status => 0)
    redirect_to :back
  end

  private

  	def auth
       unless logged_in?
      		redirect_to login_path, note: "You need to log in first"
       end
  	end
end
