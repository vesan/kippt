require "spec_helper"

describe Kippt::Favorite do
  describe "#save" do
    let(:client) { double :client }
    let(:clip) { double :clip }
    let(:collection) { double :likes_collection_resource }
    let(:favorite) { Kippt::Favorite.new(clip, client) }

    it "tells collection resource to save itself" do
      expect(collection).to receive(:save_resource).with(favorite).and_return({success: true})
      expect(client).to receive(:collection_resource_for).with(Kippt::Favorites, clip).and_return(collection)

      expect(favorite.save).to be_truthy
    end

    it "sets errors if there is any" do
      allow(collection).to receive(:save_resource).and_return({success: false, error_message: "PROBLEM"})
      allow(client).to receive(:collection_resource_for).and_return(collection)

      expect(favorite.save).to be_falsey
      expect(favorite.errors).to eq ["PROBLEM"]
    end
  end

  describe "#destroy" do
    let(:client) { double :client }
    let(:clip) { double :clip }
    let(:collection) { double :likes_collection_resource }
    let(:favorite) { Kippt::Favorite.new(clip, client) }

    it "tells collection resource to destroy itself" do
      allow(client).to receive(:collection_resource_for).and_return(collection)
      expect(collection).to receive(:destroy_resource).with(favorite).and_return(true)
      expect(favorite.destroy).to be_truthy
    end
  end
end
