require "spec_helper"
require "kippt/follow_relationship"

describe Kippt::FollowRelationship do
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  let(:user) { stub :user, :id => 10 }
  subject { Kippt::FollowRelationship.new(client, user) }

  describe "#following?" do
    it "returns boolean" do
      stub_get("/users/10/relationship/").
        to_return(:status => 200, :body => '{"following": true}')
      subject.following?.should be_true
    end
  end

  describe "#follow" do
    it "updates the value on the server" do
      stub_post("/users/10/relationship/").
         with(:body => "{\"action\":\"follow\"}").
         to_return(:status => 200, :body => "", :headers => {})
      subject.follow.should be_true
    end
  end

  describe "#unfollow" do
    it "updates the value on the server" do
      stub_post("/users/10/relationship/").
         with(:body => "{\"action\":\"unfollow\"}").
         to_return(:status => 200, :body => "", :headers => {})
      subject.unfollow.should be_true
    end
  end
end
