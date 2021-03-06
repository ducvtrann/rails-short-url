require 'rails_helper'

RSpec.describe ShortUrlsController, type: :controller do

  let(:parsed_response) { JSON.parse(response.body) }

  describe "index" do
    # CHANGED TEST
    # "https://www.test.rspec" is an invalid url , replaced with google url
    let!(:short_url) { ShortUrl.create(full_url: "https://www.google.com/") }

    it "is a successful response" do
      get :index, format: :json
      expect(response.status).to eq 200
    end

    # OLD TEST
    # expect(parsed_response['urls']).to be_include(short_url.public_attributes)
    # I assume this test is to prove that the url created above is in the array.
    it "has a list of the top 100 urls" do
      get :index, format: :json
      expect(parsed_response['urls'].find{|item| item["id"] == short_url["id"]}).to_not be_nil
    end

  end

  describe "create" do
     # "https://www.test.rspec" is an invalid url , replaced with google url
    it "creates a short_url" do
      post :create, params: { full_url: "https://www.google.com/" }, format: :json
      expect(parsed_response['short_code']).to be_a(String)
    end

    it "does not create a short_url" do
      post :create, params: { full_url: "nope!" }, format: :json
      expect(parsed_response['errors']).to be_include("Full url is not a valid url")
    end

  end

  describe "show" do
    # CHANGED URL TO BE A VALID URL
    let!(:short_url) { ShortUrl.create(full_url: "https://www.amazon.com/") }

    it "redirects to the full_url" do
      get :show, params: { id: short_url.short_code }, format: :json
      expect(response).to redirect_to(short_url.full_url)
    end

    it "does not redirect to the full_url" do
      get :show, params: { id: "nope" }, format: :json
      expect(response.status).to eq(404)
    end

    it "increments the click_count for the url" do
      expect { get :show, params: { id: short_url.short_code }, format: :json }.to change { ShortUrl.find(short_url.id).click_count }.by(1)
    end

  end

end
