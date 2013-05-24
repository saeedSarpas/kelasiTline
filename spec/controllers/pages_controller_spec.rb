require 'spec_helper'

describe PagesController do

  describe "GET 'timeline'" do
    it "returns http success" do
      get 'timeline'
      response.should be_success
    end
  end

end
