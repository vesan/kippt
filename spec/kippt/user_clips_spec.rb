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

  describe "#build" do
    it "returns new resource" do
      expect(subject.build).to be_a(resource_class)
    end

    it "accepts parameters" do
      expect(subject.object_class).to receive(:new).with({:an => "attribute"}, client)
      subject.build(:an => "attribute")
    end
  end

  describe "#favorites" do
    it "returns ClipCollection" do
      stub_get("/#{base_uri}/favorites").
        to_return(:status => 200, :body => fixture("clips.json"))
      expect(subject.favorites).to be_a Kippt::Clips
    end
  end

  describe "#likes" do
    it "returns ClipCollection" do
      stub_get("/#{base_uri}/likes").
        to_return(:status => 200, :body => fixture("clips.json"))
      expect(subject.likes).to be_a Kippt::Clips
    end
  end
end
