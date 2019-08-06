require "rails_helper"

describe “add an idea”, :type => :request do
  before do
    post ‘/api/v1/ideas’
  end
  it ‘returns a created status’ do
    expect(response).to have_http_status(201)
  end
end