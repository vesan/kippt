require "spec_helper"
require "kippt/user"

describe Kippt::User do
  subject { Kippt::User.new(data, collection_resource) }
  let(:collection_resource) { Kippt::Client.new(valid_user_credentials).users }

  let(:data) { MultiJson.load(fixture("user.json").read) }
  let(:attributes) {
    [:username, :bio, :app_url, :avatar_url, :twitter,
     :id, :github, :website_url, :full_name, :dribble,
     :counts, :resource_uri]
  }

  it_behaves_like "resource"

  describe "#pro?" do
    it "gets data from is_pro" do
      user = Kippt::User.new({:is_pro => true}, nil)
      user.pro?.should be_true
    end
  end
end
