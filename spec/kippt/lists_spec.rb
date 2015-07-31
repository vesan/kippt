require "spec_helper"
require "kippt/lists"

describe Kippt::Lists do
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  subject { client.lists }
  let(:base_uri) { "lists" }
  let(:singular_fixture) { "list" }
  let(:collection_fixture) { "lists" }
  let(:collection_class) { Kippt::ListCollection }
  let(:resource_class) { Kippt::List }

  it_behaves_like "collection resource"

  describe "#build" do
    it "returns new resource" do
      expect(subject.build).to be_a(resource_class)
    end

    it "accepts parameters" do
      expect(subject.object_class).to receive(:new).with({:an => "attribute"}, client)
      subject.build(:an => "attribute")
    end
  end
end
