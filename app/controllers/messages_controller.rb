class MessagesController < ApplicationController

  def index
	  @our_names = { 1 => "Saeid", 2 => "Amir", 3 => "Sadegh" }
  	@messages = Messages.all
  end
end
