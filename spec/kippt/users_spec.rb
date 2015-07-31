require "spec_helper"
require "kippt/users"

describe Kippt::Users do
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  subject { client.users }
  let(:base_uri) { "users" }
  let(:singular_fixture) { "user" }
  let(:collection_fixture) { "users" }
  let(:collection_class) { Kippt::UserCollection }
  let(:resource_class) { Kippt::User }

  it_behaves_like "read collection resource"

  describe "#search" do
    subject { Kippt::Client.new(valid_user_credentials).users }

    describe "parameters" do
      context "when parameter is a String" do
        it "does the search with the string being q" do
          stub_get("/users/search?q=bunny").
            to_return(:status => 200, :body => fixture("users_with_multiple_pages.json"))
          subject.search("bunny")
        end
      end

      context "when parameter is a Hash" do
        context "with accepted keys" do
          it "does the search" do
            stub_get("/users/search?q=bunny").
              to_return(:status => 200, :body => fixture("users_with_multiple_pages.json"))
            subject.search(:q => "bunny")
          end
        end

        context "with invalid keys" do
          it "raises ArgumentError" do
            expect {
              subject.search(:q => "bunny", :stuff => true)
            }.to raise_error(ArgumentError, "'stuff' is not a valid search parameter")
          end
        end
      end
    end

    it "returns UserCollection" do
      stub_get("/users/search?q=bunny").
        to_return(:status => 200, :body => fixture("users_with_multiple_pages.json"))
      users = subject.search("bunny")
      expect(users).to be_a Kippt::UserCollection
    end

    it "sets UserCollection client" do
      stub_get("/users/search?q=bunny").
        to_return(:status => 200, :body => fixture("users_with_multiple_pages.json"))
      expect(Kippt::UserCollection).to receive(:new).with(kind_of(Hash), kind_of(Kippt::Client))
      users = subject.search("bunny")
    end
  end
end
