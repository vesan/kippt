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
        expect(subject.list_uri).to eq "/api/lists/44525/"
      end
    end

    context "when API data has embedded list attributes" do
      let(:data) { {"list" => {"resource_uri" => "/api/lists/44525/"}} }

      it "returns the uri of the embedded list" do
        expect(subject.list_uri).to eq "/api/lists/44525/"
      end
    end
  end

  describe "#list" do
    context "when API data has an list URI" do
      let(:data) { {"list" => "/api/lists/44525/"} }

      it "fetches the data and creates an instance out of it" do
        stub_get("/lists/44525/").
          to_return(:status => 200, :body => fixture("list.json"))

        expect(subject.list).to be_a Kippt::List
      end
    end

    context "when API data has embedded list attributes" do
      let(:data) { {"list" => {"resource_uri" => "/api/lists/44525/"}} }

      it "returns an instance using the embedded list" do
        expect(subject.list).to be_a Kippt::List
      end
    end

    context "when a Kippt::List is passed" do
      let(:list) { Kippt::List.new }
      let(:data) { {"list" => list} }

      it "returns the passed list" do
        expect(subject.list).to eq list
      end
    end
  end

  describe "#comments" do
    it "returns Kippt::Comments" do
      expect(subject.comments).to be_a Kippt::Comments
    end

    it "returns object where clip is set" do
      expect(subject.comments.clip).to eq subject
    end
  end

  describe "#all_comments_embedded?" do
    context "when comment count and number of comment objects matches" do
      let(:data) { {"comments" => {
        "count" => 2, "data" => [{}, {}]
      }} }

      it "returns true" do
        expect(subject.all_comments_embedded?).to be_truthy
      end
    end

    context "when comment count and number of comment objects doesn't match" do
      let(:data) { {"comments" => {
        "count" => 2, "data" => [{}]
      }} }

      it "returns false" do
        expect(subject.all_comments_embedded?).to be_falsey
      end
    end
  end

  describe "#likes" do
    it "returns Kippt::ClipLikes" do
      expect(subject.likes).to be_a Kippt::ClipLikes
    end

    it "returns object where clip is set" do
      expect(subject.likes.clip).to eq subject
    end
  end

  describe "#all_likes_embedded?" do
    context "when like count and number of like objects matches" do
      let(:data) { {"likes" => {
        "count" => 2, "data" => [{}, {}]
      }} }

      it "returns true" do
        expect(subject.all_likes_embedded?).to be_truthy
      end
    end

    context "when like count and number of like objects doesn't match" do
      let(:data) { {"likes" => {
        "count" => 2, "data" => [{}]
      }} }

      it "returns false" do
        expect(subject.all_likes_embedded?).to be_falsey
      end
    end
  end

  describe "#likes_count" do
    it "returns the likes count from the response" do
      expect(subject.likes_count).to eq 0
    end
  end

  describe "#likes_data" do
    it "returns the likes data from the response" do
      expect(subject.likes_data).to eq []
    end
  end

  describe "#saves" do
    it "returns Kippt::Saves" do
      expect(subject.saves).to be_a Kippt::Saves
    end

    it "returns object where clip is set" do
      expect(subject.saves.clip).to eq subject
    end
  end

  describe "#saves_count" do
    it "returns the saves count from the response" do
      expect(subject.saves_count).to eq 0
    end
  end

  describe "#saves_data" do
    it "returns the saves data from the response" do
      expect(subject.saves_data).to eq []
    end
  end

  describe "#like" do
    let(:like) { double :like }

    it "instantiates a Kippt::Like and saves it" do
      expect(Kippt::Like).to receive(:new).with(subject, client).and_return(like)
      expect(like).to receive(:save)
      subject.like
    end
  end

  describe "#unlike" do
    let(:like) { double :like }

    it "instantiates a Kippt::Like and destroys it" do
      expect(Kippt::Like).to receive(:new).with(subject, client).and_return(like)
      expect(like).to receive(:destroy)
      subject.unlike
    end
  end

  describe "#favorite" do
    let(:favorite) { double :favorite }

    it "instantiates a Kippt::Favorite and saves it" do
      expect(Kippt::Favorite).to receive(:new).with(subject, client).and_return(favorite)
      expect(favorite).to receive(:save)
      subject.favorite
    end
  end

  describe "#unlike" do
    let(:favorite) { double :favorite }

    it "instantiates a Kippt::Favorite and destroys it" do
      expect(Kippt::Favorite).to receive(:new).with(subject, client).and_return(favorite)
      expect(favorite).to receive(:destroy)
      subject.unfavorite
    end
  end
end
