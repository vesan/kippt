require "spec_helper"
require "kippt/clip"

describe Kippt::Clip do
  subject { Kippt::Clip.new(data, client) }
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  let(:collection_resource_class) { Kippt::Clips }

  let(:data) { MultiJson.load(fixture("clip.json").read) }
  let(:attributes) {
    [:url_domain, :is_starred, :title,
     :url, :notes, :id, :resource_uri]
   }
   let(:mapped_attributes) {
     {:updated => "Time", :created => "Time",
      :user => "Kippt::User", :via => "Kippt::Clip"}
   }

  it_behaves_like "resource"

  describe "#list_uri" do
    context "when API data has an list URI" do
      let(:data) { {"list" => "/api/lists/44525/"} }

      it "returns the URI" do
        subject.list_uri.should eq "/api/lists/44525/"
      end
    end

    context "when API data has embedded list attributes" do
      let(:data) { {"list" => {"resource_uri" => "/api/lists/44525/"}} }

      it "returns the uri of the embedded list" do
        subject.list_uri.should eq "/api/lists/44525/"
      end
    end
  end

  describe "#list" do
    context "when API data has an list URI" do
      let(:data) { {"list" => "/api/lists/44525/"} }

      it "fetches the data and creates an instance out of it" do
        stub_get("/lists/44525/").
          to_return(:status => 200, :body => fixture("list.json"))

        subject.list.should be_a Kippt::List
      end
    end

    context "when API data has embedded list attributes" do
      let(:data) { {"list" => {"resource_uri" => "/api/lists/44525/"}} }

      it "returns an instance using the embedded list" do
        subject.list.should be_a Kippt::List
      end
    end

    context "when a Kippt::List is passed" do
      let(:list) { Kippt::List.new }
      let(:data) { {"list" => list} }

      it "returns the passed list" do
        subject.list.should eq list
      end
    end
  end

  describe "#comments" do
    it "returns Kippt::Comments" do
      subject.comments.should be_a Kippt::Comments
    end

    it "returns object where clip is set" do
      subject.comments.clip.should eq subject
    end
  end

  describe "#all_comments_embedded?" do
    context "when comment count and number of comment objects matches" do
      let(:data) { {"comments" => {
        "count" => 2, "data" => [{}, {}]
      }} }

      it "returns true" do
        subject.all_comments_embedded?.should be_truthy
      end
    end

    context "when comment count and number of comment objects doesn't match" do
      let(:data) { {"comments" => {
        "count" => 2, "data" => [{}]
      }} }

      it "returns false" do
        subject.all_comments_embedded?.should be_falsey
      end
    end
  end

  describe "#likes" do
    it "returns Kippt::ClipLikes" do
      subject.likes.should be_a Kippt::ClipLikes
    end

    it "returns object where clip is set" do
      subject.likes.clip.should eq subject
    end
  end

  describe "#all_likes_embedded?" do
    context "when like count and number of like objects matches" do
      let(:data) { {"likes" => {
        "count" => 2, "data" => [{}, {}]
      }} }

      it "returns true" do
        subject.all_likes_embedded?.should be_truthy
      end
    end

    context "when like count and number of like objects doesn't match" do
      let(:data) { {"likes" => {
        "count" => 2, "data" => [{}]
      }} }

      it "returns false" do
        subject.all_likes_embedded?.should be_falsey
      end
    end
  end

  describe "#likes_count" do
    it "returns the likes count from the response" do
      subject.likes_count.should eq 0
    end
  end

  describe "#likes_data" do
    it "returns the likes data from the response" do
      subject.likes_data.should eq []
    end
  end

  describe "#saves" do
    it "returns Kippt::Saves" do
      subject.saves.should be_a Kippt::Saves
    end

    it "returns object where clip is set" do
      subject.saves.clip.should eq subject
    end
  end

  describe "#saves_count" do
    it "returns the saves count from the response" do
      subject.saves_count.should eq 0
    end
  end

  describe "#saves_data" do
    it "returns the saves data from the response" do
      subject.saves_data.should eq []
    end
  end

  describe "#like" do
    let(:like) { double :like }

    it "instantiates a Kippt::Like and saves it" do
      Kippt::Like.should_receive(:new).with(subject, client).and_return(like)
      like.should_receive(:save)
      subject.like
    end
  end

  describe "#unlike" do
    let(:like) { double :like }

    it "instantiates a Kippt::Like and destroys it" do
      Kippt::Like.should_receive(:new).with(subject, client).and_return(like)
      like.should_receive(:destroy)
      subject.unlike
    end
  end

  describe "#favorite" do
    let(:favorite) { double :favorite }

    it "instantiates a Kippt::Favorite and saves it" do
      Kippt::Favorite.should_receive(:new).with(subject, client).and_return(favorite)
      favorite.should_receive(:save)
      subject.favorite
    end
  end

  describe "#unlike" do
    let(:favorite) { double :favorite }

    it "instantiates a Kippt::Favorite and destroys it" do
      Kippt::Favorite.should_receive(:new).with(subject, client).and_return(favorite)
      favorite.should_receive(:destroy)
      subject.unfavorite
    end
  end
end
