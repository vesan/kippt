require "spec_helper"
require "kippt/comments"

describe Kippt::Comments do
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  let(:clip) { double :clip, :id => 100, :all_comments_embedded? => false }
  subject { Kippt::Comments.new(client, clip) }
  let(:base_uri) { "clips/#{clip.id}/comments" }
  let(:singular_fixture) { "comment" }
  let(:collection_class) { Kippt::CommentCollection }
  let(:resource_class) { Kippt::Comment }

  it_behaves_like "collection resource"

  def collection_fixture
    base_uri.split("/").last
  end

  describe "#build" do
    it "returns new resource" do
      expect(subject.build).to be_a(resource_class)
    end

    it "accepts parameters" do
      expect(subject.object_class).to receive(:new).with({:an => "attribute"}, client, clip)
      subject.build({:an => "attribute"})
    end
  end


  describe "#fetch" do
    it "returns collection class" do
      stub_get("/#{base_uri}").
        to_return(:status => 200, :body => fixture("#{collection_fixture}.json"))
      all_resources = subject.fetch
      all_resources.is_a? collection_class
    end

    it "accepts limit and offset options" do
      stub_get("/#{base_uri}?limit=10&offset=100").
        to_return(:status => 200, :body => fixture("#{collection_fixture}.json"))
      resources = subject.fetch(:limit => 10, :offset => 100)
    end

    context "when comments are embedded" do
      let(:clip) { double :clip,
                          id: 100,
                          all_comments_embedded?: true,
                          comments_data: [{body: "Embedded body"}] }

      it "uses the embedded data to create comments" do
        comments = subject.fetch
        expect(comments.first.body).to eq "Embedded body"
      end
    end

    context "when passed unrecognized arguments" do
      it "raises error" do
        expect {
          subject.fetch(:foobar => true)
        }.to raise_error(
          ArgumentError, "Unrecognized argument: foobar")
      end
    end
  end

  describe "#[]" do
    it "fetches single resource" do
      stub_get("/#{base_uri}/10").
        to_return(:status => 200, :body => fixture("#{singular_fixture}.json"))
      expect(subject[10].id).to eq 10
    end

    it "returns resource" do
      stub_get("/#{base_uri}/10").
        to_return(:status => 200, :body => fixture("#{singular_fixture}.json"))
      expect(subject[10]).to be_a(resource_class)
    end

    context "when resource is not found" do
      it "raises exception" do
        stub_get("/#{base_uri}/10").
          to_return(:status => 404, :body => {"message" => "Resource not found."}.to_json)
        expect {
          subject[10]
        }.to raise_error(
          Kippt::APIError, "Resource could not be loaded: Resource not found.")
      end
    end
  end

  describe "#find" do
    it "exists" do
      expect(subject.respond_to?(:find)).to be_truthy
    end
  end

  describe "#build" do
    it "returns new resource" do
      expect(subject.build).to be_a(resource_class)
    end

    it "accepts parameters" do
      expect(subject.object_class).to receive(:new).with({:an => "attribute"}, client, clip)
      subject.build(:an => "attribute")
    end
  end
end
