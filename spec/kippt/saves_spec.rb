require "spec_helper"
require "kippt/saves"

describe Kippt::Saves do
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  let(:clip) { stub :clip, :saves_data => fixture("users.json") }
  subject { Kippt::Saves.new(client, clip) }

  describe "#all" do
    it "returns collection class" do
      all_resources = subject.all
      all_resources.is_a? Kippt::UserCollection
    end

    it "uses the clip saves data" do
      Kippt::UserCollection.should_receive(:new).with({"objects" => clip.saves_data}, client)
      subject.all
    end
  end
end
