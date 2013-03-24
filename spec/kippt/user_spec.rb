require "spec_helper"
require "kippt/user"

describe Kippt::User do
  subject { Kippt::User.new(data, client) }
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  let(:collection_resource_class) { Kippt::Users }

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
