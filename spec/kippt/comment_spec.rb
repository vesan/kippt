require "spec_helper"
require "kippt/comment"

describe Kippt::Comment do
  subject { Kippt::Comment.new(data, client, clip) }
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  let(:clip) { stub(:clip) }
  let(:collection_resource_class) { Kippt::Comments }

  let(:data) { MultiJson.load(fixture("comment.json").read) }
  let(:attributes) {
    [:body, :created, :id, :resource_uri]
   }

  it_behaves_like "resource"

  describe "#clip" do
    it "returns the clip passed to it" do
      subject.clip.should eq clip
    end
  end
end
