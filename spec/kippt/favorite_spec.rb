require "spec_helper"

describe Kippt::Favorite do
  describe "#save" do
    let(:client) { double :client }
    let(:clip) { double :clip }
    let(:collection) { double :likes_collection_resource }
    let(:favorite) { Kippt::Favorite.new(clip, client) }

    it "tells collection resource to save itself" do
      collection.should_receive(:save_resource).with(favorite).and_return({success: true})
      client.should_receive(:collection_resource_for).with(Kippt::Favorites, clip).and_return(collection)

      favorite.save.should be_truthy
    end

    it "sets errors if there is any" do
      collection.stub(:save_resource).and_return({success: false, error_message: "PROBLEM"})
      client.stub(:collection_resource_for).and_return(collection)

      favorite.save.should be_falsey
      favorite.errors.should eq ["PROBLEM"]
    end
  end

  describe "#destroy" do
    let(:client) { double :client }
    let(:clip) { double :clip }
    let(:collection) { double :likes_collection_resource }
    let(:favorite) { Kippt::Favorite.new(clip, client) }

    it "tells collection resource to destroy itself" do
      client.stub(:collection_resource_for).and_return(collection)
      collection.should_receive(:destroy_resource).with(favorite).and_return(true)
      favorite.destroy.should be_truthy
    end
  end
end
