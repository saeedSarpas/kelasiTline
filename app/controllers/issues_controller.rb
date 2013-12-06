class IssuesController < ApplicationController

	around_filter :login, except: :index
	respond_to :json

	def index
		user = User.first
		@issues = user.github.issues repo
		respond_with @issues
	end

	def create
		title   = params[:title]
		body    = params[:body]
		options = (params[:options] || {}).select {|k|
			['assignee', 'milestone', 'labels'].include? k
		}
		@issue = current_user.github.create_issue(repo, title, body, options)
		render json: @issue
	end

	def update
		number = params[:id]
		title = params[:title]
		body = params[:body]
		options = (params[:options] || {}).select {|k|
			['assignee', 'milestone', 'labels', 'state'].include? k
		}
		@issue = current_user.github.update_issue(repo, number, title, body, options)
		render json: @issue
	end

	def destroy
		number = params[:id]
		options = (params[:options] || {}).select {|k|
			['assignee', 'milestone', 'labels', 'state'].include? k
		}
		@issue = current_user.github.close_issue(repo, number, options)
		render json: @issue
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
