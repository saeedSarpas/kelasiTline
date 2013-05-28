class PostsController < ApplicationController

  def index
	  @our_names = { 1 => "Saeed", 2 => "Amir", 3 => "Sadegh", 4 => "Hamed", 5 => "Pouria" }
  	@posts = Post.order("created_at DESC").limit(20).where("parent=0")
    q = ""
    @posts.each do |post|
      if q != ""
        q = "#{q} or parent = #{post.id}" 
      else
        q = "parent = #{post.id}"
      end
    end
    @replies = Post.order("created_at").where(q)
  end

  def create
    @message = Post.new params[:user_params]
    @message.save
    redirect_to root_path
  end
end
