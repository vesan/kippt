require "spec_helper"
require "kippt/user_clips"

describe Kippt::UserClips do
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  subject { Kippt::User.new({:id => 10}, client).clips }
  let(:base_uri) { "users/#{10}/clips" }
  let(:singular_fixture) { "clip" }
  let(:collection_fixture) { "clips" }
  let(:collection_class) { Kippt::ClipCollection }
  let(:resource_class) { Kippt::Clip }

  it_behaves_like "collection resource"

  describe "#favorites" do
    it "returns ClipCollection" do
      stub_get("/#{base_uri}/favorites").
        to_return(:status => 200, :body => fixture("clips.json"))
      subject.favorites.should be_a Kippt::Clips
    end
  end

  describe "#likes" do
    it "returns ClipCollection" do
      stub_get("/#{base_uri}/likes").
        to_return(:status => 200, :body => fixture("clips.json"))
      subject.likes.should be_a Kippt::Clips
    end
  end
end
