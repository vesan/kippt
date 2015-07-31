require "spec_helper"
require "kippt/follow_relationship"

describe Kippt::FollowRelationship do
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  let(:user) { double :user, :id => 10 }
  subject { Kippt::FollowRelationship.new(client, user) }

  describe "#following?" do
    it "returns boolean" do
      stub_get("/users/10/relationship/").
        to_return(:status => 200, :body => '{"following": true}')
      subject.following?.should be_truthy
    end

    context "when request is not successful" do
      it "raises an exception" do
        fail_response = double :fail_response, success?: false, body: {"message" => "NOT FOUND"}
        client.stub(:get).and_return(fail_response)
        expect {
          subject.following?
        }.to raise_exception Kippt::APIError, "Resource could not be loaded: NOT FOUND"
      end
    end
  end

  describe "#follow" do
    it "updates the value on the server" do
      stub_post("/users/10/relationship/").
         with(:body => "{\"action\":\"follow\"}").
         to_return(:status => 200, :body => "", :headers => {})
      subject.follow.should be_truthy
    end

    context "when request is not successful" do
      it "raises an exception" do
        fail_response = double :fail_response, success?: false, body: {"message" => "NOT FOUND"}
        client.stub(:post).and_return(fail_response)
        expect {
          subject.follow
        }.to raise_exception Kippt::APIError, "Problem with following: NOT FOUND"
      end
    end
  end

  describe "#unfollow" do
    it "updates the value on the server" do
      stub_post("/users/10/relationship/").
         with(:body => "{\"action\":\"unfollow\"}").
         to_return(:status => 200, :body => "", :headers => {})
      subject.unfollow.should be_truthy
    end

    context "when request is not successful" do
      it "raises an exception" do
        fail_response = double :fail_response, success?: false, body: {"message" => "NOT FOUND"}
        client.stub(:post).and_return(fail_response)
        expect {
          subject.unfollow
        }.to raise_exception Kippt::APIError, "Problem with unfollowing: NOT FOUND"
      end
    end
  end
end
