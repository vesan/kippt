require "spec_helper"
require "kippt/saves"

describe Kippt::Saves do
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  let(:clip) { double :clip, :saves_data => fixture("users.json") }
  subject { Kippt::Saves.new(client, clip) }

  describe "#fetch" do
    it "returns collection class" do
      all_resources = subject.fetch
      all_resources.is_a? Kippt::UserCollection
    end

    it "uses the clip saves data" do
      expect(Kippt::UserCollection).to receive(:new).with({"objects" => clip.saves_data}, client)
      subject.fetch
    end
  end
end
