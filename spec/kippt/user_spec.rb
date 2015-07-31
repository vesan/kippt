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
  let(:mapped_attributes) {
    {}
  }

  it_behaves_like "resource"

  describe "#pro?" do
    it "gets data from is_pro" do
      user = Kippt::User.new({:is_pro => true}, nil)
      expect(user.pro?).to be_truthy
    end
  end

  describe "#likes" do
    it "returns correctly configured user likes proxy" do
      client = double :client
      user = Kippt::User.new(nil, client)

      likes = user.likes
      expect(likes).to be_a(Kippt::UserLikes)
      expect(likes.user).to eq user
    end
  end

  describe "#following?" do
    it "uses Kippt::FollowRelationship to get the information" do
      follow_relationship = double(:follow_relationship,
        :following? => true)
      allow(Kippt::FollowRelationship).to receive(:new).and_return(follow_relationship)
      user = Kippt::User.new({:is_pro => true}, nil)
      expect(user.following?).to be_truthy
    end
  end

  describe "#follower_count" do
    it "returns the count from the fetched data" do
      user = Kippt::User.new({:counts => {"follows" => 11}})
      expect(user.follower_count).to eq 11
    end
  end

  describe "#following_count" do
    it "returns the count from the fetched data" do
      user = Kippt::User.new({:counts => {"followed_by" => 111}})
      expect(user.following_count).to eq 111
    end
  end

  describe "#follow" do
    it "sets up a Kippt::FollowRelationship and calls it" do
      follow_relationship = double(:follow_relationship,
        :follow => true)
      allow(Kippt::FollowRelationship).to receive(:new).and_return(follow_relationship)
      user = Kippt::User.new
      expect(user.follow).to be_truthy
    end
  end

  describe "#unfollow" do
    it "sets up a Kippt::FollowRelationship and calls it" do
      follow_relationship = double(:follow_relationship,
        :unfollow => true)
      allow(Kippt::FollowRelationship).to receive(:new).and_return(follow_relationship)
      user = Kippt::User.new
      expect(user.unfollow).to be_truthy
    end
  end
end
