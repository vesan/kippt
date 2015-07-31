require "spec_helper"
require "kippt/list"

describe Kippt::List do
  subject { Kippt::List.new(data, client) }
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  let(:collection_resource_class) { Kippt::Lists }

  let(:data) { json_fixture("list.json") }
  let(:attributes) {
    [:id, :rss_url, :title,
     :slug, :resource_uri]
  }
   let(:mapped_attributes) {
     {:updated => "Time", :created => "Time",
      :user => "Kippt::User"}
   }

  it_behaves_like "resource"

  describe "#private?" do
    it "gets data from is_private" do
      list = Kippt::List.new({"is_private" => true}, nil)
      expect(list.private?).to be_truthy
    end
  end

  describe "#collaborators" do
    it "returns the users generated from the data" do
      list = Kippt::List.new({"collaborators" => {"count" => 1, "data" => [json_fixture("user.json")]}}, nil)
      expect(list.collaborators.size).to eq 1
      expect(list.collaborators.first).to be_a Kippt::User
    end
  end

  describe "#clips" do
    subject { Kippt::List.new({ "id" => 10 }, client).clips }

    it "returns the clips for the list" do
      stub_get("/lists/10/clips").
        to_return(:status => 200, :body => fixture("clips.json"))
      expect(subject).to be_a Kippt::Clips
      expect(subject.base_uri).to eq "lists/10/clips"
    end
  end

  describe "#following?" do
    context "when request is successful" do
      let(:client) { Kippt::Client.new(valid_user_credentials) }

      it "returns value from the response" do
        response = double(:response, :success? => true, body: {"following" => false})
        expect(client).to receive(:get).with("/api/lists/10/relationship").and_return(response)
        list = Kippt::List.new(json_fixture("list.json"), client)
        expect(list.following?).to be_falsey
      end

      it "makes a request" do
        stub_request(:get, "https://kippt.com/api/lists/10/relationship").
           to_return(:status => 200, :body => "{\"following\":true}")
        list = Kippt::List.new(json_fixture("list.json"), client)
        list.following?
      end
    end

    context "when request is unsuccessful" do
      it "raises an exception" do
        response = double(:response, :success? => false, :body => {"message" => "Weird issue going on."})
        expect(client).to receive(:get).with("/api/lists/10/relationship").and_return(response)
        list = Kippt::List.new(json_fixture("list.json"), client)

        expect {
          list.following?
        }.to raise_error(Kippt::APIError, "There was an error with the request: Weird issue going on.")
      end
    end
  end

  describe "#follow" do
    context "when request is successful" do
      let(:client) { Kippt::Client.new(valid_user_credentials) }

      it "returns true" do
        response = double(:response, :success? => true)
        expect(client).to receive(:post).with("/api/lists/10/relationship", :data => {:action => "follow"}).and_return(response)
        list = Kippt::List.new(json_fixture("list.json"), client)
        expect(list.follow).to eq true
      end

      it "makes a request" do
        stub_request(:post, "https://kippt.com/api/lists/10/relationship").
           with(:body => "{\"action\":\"follow\"}").
           to_return(:status => 200, :body => "{\"folloring\":true}")
        list = Kippt::List.new(json_fixture("list.json"), client)
        list.follow
      end
    end

    context "when request is unsuccessful" do
      it "raises an exception" do
        response = double(:response, :success? => false, :body => {"message" => "Weird issue going on."})
        expect(client).to receive(:post).with("/api/lists/10/relationship", :data => {:action => "follow"}).and_return(response)
        list = Kippt::List.new(json_fixture("list.json"), client)

        expect {
          list.follow
        }.to raise_error(Kippt::APIError, "There was an error with the request: Weird issue going on.")
      end
    end
  end

  describe "#unfollow" do
    context "when request is successful" do
      let(:client) { Kippt::Client.new(valid_user_credentials) }

      it "returns true" do
        response = double(:response, :success? => true)
        expect(client).to receive(:post).with("/api/lists/10/relationship", :data => {:action => "unfollow"}).and_return(response)
        list = Kippt::List.new(json_fixture("list.json"), client)
        expect(list.unfollow).to eq true
      end

      it "makes a request" do
        stub_request(:post, "https://kippt.com/api/lists/10/relationship").
           with(:body => "{\"action\":\"unfollow\"}").
           to_return(:status => 200, :body => "{\"folloring\":false}")
        list = Kippt::List.new(json_fixture("list.json"), client)
        list.unfollow
      end
    end

    context "when request is unsuccessful" do
      it "raises an exception" do
        response = double(:response, :success? => false, :body => {"message" => "Weird issue going on."})
        expect(client).to receive(:post).with("/api/lists/10/relationship", :data => {:action => "unfollow"}).and_return(response)
        list = Kippt::List.new(json_fixture("list.json"), client)

        expect {
          list.unfollow
        }.to raise_error(Kippt::APIError, "There was an error with the request: Weird issue going on.")
      end
    end
  end
end
