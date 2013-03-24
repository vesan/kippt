require "spec_helper"
require "kippt/clip"

describe Kippt::Clip do
  subject { Kippt::Clip.new(data, client) }
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  let(:collection_resource_class) { Kippt::Clips }

  let(:data) { MultiJson.load(fixture("clip.json").read) }
  let(:attributes) {
    [:url_domain, :updated, :is_starred, :title,
     :url, :notes, :created, :id, :resource_uri]
   }

  it_behaves_like "resource"

  describe "#list_uri" do
    context "when API data has an list URI" do
      let(:data) { {"list" => "/api/lists/44525/"} }

      it "returns the URI" do
        subject.list_uri.should eq "/api/lists/44525/"
      end
    end

    context "when API data has embedded list attributes" do
      let(:data) { {"list" => {"resource_uri" => "/api/lists/44525/"}} }

      it "returns the uri of the embedded list" do
        subject.list_uri.should eq "/api/lists/44525/"
      end
    end
  end

  describe "#list" do
    context "when API data has an list URI" do
      let(:data) { {"list" => "/api/lists/44525/"} }

      it "fetches the data and creates an instance out of it" do
        stub_get("/lists/44525/").
          to_return(:status => 200, :body => fixture("list.json"))

        subject.list.should be_a Kippt::List
      end
    end

    context "when API data has embedded list attributes" do
      let(:data) { {"list" => {"resource_uri" => "/api/lists/44525/"}} }

      it "returns an instance using the embedded list" do
        subject.list.should be_a Kippt::List
      end
    end
  end
end
