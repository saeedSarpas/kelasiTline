class PostsController < ApplicationController

  def index
	  @our_names = { 1 => "Saeed", 2 => "Amir", 3 => "Sadegh", 4 => "Hamed", 5 => "Pouria" }
  	@posts = Post.order("created_at DESC").limit(20).where("parent=0 and status=1")
    q = ""
    @posts.each do |post|
      if q != ""
        q = "#{q} or parent = #{post.id}" 
      else
        q = "parent = #{post.id}"
      end
      q= "#{q} and status=1"
    end
    @replies = Post.order("created_at DESC").where(q)
    @allPosts = @posts+@replies
    ActiveRecord::Base.include_root_in_json = true
    respond_to do |format|
      format.html
      format.json { render json: @allPosts.to_json( except: ["updated_at"]) }
    end
  end

  def create
    @message = Post.new params[:user_params]
    @message.save
    redirect_to :back, :status => 301
  end

  def destroy
    @post = Post.where("id = #{params[:id]} or parent = #{params[:id]}")
    @post.update_all(:status => 0)
    redirect_to :back
  end
end
