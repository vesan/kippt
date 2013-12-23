require "spec_helper"
require "kippt/user_lists"

describe Kippt::UserLists do
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  subject { Kippt::User.new({:id => 10}, client).lists }
  let(:base_uri) { "users/#{10}/lists" }
  let(:singular_fixture) { "list" }
  let(:collection_fixture) { "lists" }
  let(:collection_class) { Kippt::ListCollection }
  let(:resource_class) { Kippt::List }

  it_behaves_like "collection resource"

  describe "#build" do
    it "returns new resource" do
      subject.build.should be_a(resource_class)
    end

    it "accepts parameters" do
      subject.object_class.should_receive(:new).with({:an => "attribute"}, client)
      subject.build(:an => "attribute")
    end
  end
end
