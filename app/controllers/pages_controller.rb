class PagesController < ApplicationController

  def ng
  end

  def timeline
  end

  def login
  end

  def do_login
  	session['user'] = User.find_by_name params['name']
    respond_to do |format|
  	  format.html { redirect_to root_path }
      format.json { render json: session['user'] }
    end
  end

  def logout
    session['user'] = nil
    redirect_to root_path
  end
end
