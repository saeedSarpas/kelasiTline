require 'spec_helper'

describe 'posts/index' do

  before do
    assign(:posts, [])
    assign(:user, id: 1, name: 'Saeed')
  end

  it 'should contain a logout link' do
    render

    expect(rendered).to have_link 'logout', href: '/logout'
  end

  it 'should contain the id of logged in user' do
    render

    expect(rendered).to have_selector %Q(input#user_id[value="1"])
  end
end
