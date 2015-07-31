require "spec_helper"

describe Kippt::Like do
  describe "#save" do
    let(:client) { double :client }
    let(:clip) { double :clip }
    let(:collection) { double :likes_collection_resource }
    let(:like) { Kippt::Like.new(clip, client) }

    it "tells collection resource to save itself" do
      expect(collection).to receive(:save_resource).with(like).and_return({success: true})
      expect(client).to receive(:collection_resource_for).with(Kippt::Likes, clip).and_return(collection)

      expect(like.save).to be_truthy
    end

    it "sets errors if there is any" do
      allow(collection).to receive(:save_resource).and_return({success: false, error_message: "PROBLEM"})
      allow(client).to receive(:collection_resource_for).and_return(collection)

      expect(like.save).to be_falsey
      expect(like.errors).to eq ["PROBLEM"]
    end
  end

  describe "#destroy" do
    let(:client) { double :client }
    let(:clip) { double :clip }
    let(:collection) { double :likes_collection_resource }
    let(:like) { Kippt::Like.new(clip, client) }

    it "tells collection resource to destroy itself" do
      allow(client).to receive(:collection_resource_for).and_return(collection)
      expect(collection).to receive(:destroy_resource).with(like).and_return(true)
      expect(like.destroy).to be_truthy
    end
  end
end
