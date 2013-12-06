class MilestonesController < ApplicationController

	around_filter :login, except: :index
	respond_to :json

	def index
		user = User.first
		@milestones = user.github.list_milestones repo
		respond_with @milestones
	end

	def create
		title = params[:title]
		options = (params[:options] || {}).select {|k|
			['state', 'description', 'due_on'].include? k
		}
		@milestone = current_user.github.create_milestone(repo, title, options)
		render json: @milestone
	end

	private
		def login
			unless logged_in?
				head :unauthorized
			else
				yield
			end
		end

		def repo
			org = params[:org]
			rpo = params[:repo]
			"#{org}/#{rpo}"
		end
end
