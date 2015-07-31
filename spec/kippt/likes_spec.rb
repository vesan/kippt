require "spec_helper"
require "kippt/likes"

describe Kippt::Likes do
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  let(:clip) { double :user, :id => 100, :all_likes_embedded? => false }
  subject { Kippt::Likes.new(client, clip) }
  let(:base_uri) { "clips/#{clip.id}/likes" }
  let(:singular_fixture) { "user" }
  let(:collection_class) { Kippt::UserCollection }
  let(:resource_class) { Kippt::User }

  describe "#destroy_resource" do
    it "uses only the base_uri" do
      like = double :like
      response = double :response, success?: true
      expect(client).to receive(:delete).with("clips/100/likes").and_return(response)
      expect(subject.destroy_resource(like)).to be_truthy
    end
  end
end
