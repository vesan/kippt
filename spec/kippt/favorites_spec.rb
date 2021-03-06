require "spec_helper"
require "kippt/favorites"

describe Kippt::Favorites do
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  let(:clip) { double :user, :id => 100, :all_favorites_embedded? => false }
  subject { Kippt::Favorites.new(client, clip) }
  let(:base_uri) { "clips/#{clip.id}/favorites" }

  describe "#destroy_resource" do
    it "uses only the base_uri" do
      favorite = double :favorite
      response = double :response, success?: true
      expect(client).to receive(:delete).with("clips/100/favorites").and_return(response)
      expect(subject.destroy_resource(favorite)).to be_truthy
    end
  end
end
