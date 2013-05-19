require "spec_helper"
require "kippt/list"

describe Kippt::List do
  subject { Kippt::List.new(data, client) }
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  let(:collection_resource_class) { Kippt::Lists }

  let(:data) { MultiJson.load(fixture("list.json").read) }
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
      list.private?.should be_true
    end
  end

  describe "#collaborators" do
    it "returns the users generated from the data" do
      list = Kippt::List.new({"collaborators" => {"count" => 1, "data" => [fixture("user.json")]}}, nil)
      list.collaborators.size.should eq 1
      list.collaborators.first.should be_a Kippt::User
    end
  end

  describe "#follow" do
    context "when request is successful" do
      let(:client) { Kippt::Client.new(valid_user_credentials) }

      it "makes a request" do
        response = stub(:success? => true)
        client.should_receive(:post).with("/api/lists/10/relationship", :data => {:action => "follow"}).and_return(response)
        list = Kippt::List.new(json_fixture("list.json"), client)
        list.follow
      end

      it "returns true" do
        stub_request(:post, "https://kippt.com/api/lists/10/relationship").
           with(:body => "{\"action\":\"follow\"}").
           to_return(:status => 200, :body => "{\"folloring\":true}")
        list = Kippt::List.new(json_fixture("list.json"), client)
        list.follow.should eq true
      end
    end

    context "when request is unsuccessful" do
      it "raises an exception" do
        response = stub(:success? => false, :body => {"message" => "Weird issue going on."})
        client.should_receive(:post).with("/api/lists/10/relationship", :data => {:action => "follow"}).and_return(response)
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

      it "makes a request" do
        response = stub(:success? => true)
        client.should_receive(:post).with("/api/lists/10/relationship", :data => {:action => "unfollow"}).and_return(response)
        list = Kippt::List.new(json_fixture("list.json"), client)
        list.unfollow
      end

      it "returns true" do
        stub_request(:post, "https://kippt.com/api/lists/10/relationship").
           with(:body => "{\"action\":\"unfollow\"}").
           to_return(:status => 200, :body => "{\"folloring\":false}")
        list = Kippt::List.new(json_fixture("list.json"), client)
        list.unfollow.should eq true
      end
    end

    context "when request is unsuccessful" do
      it "raises an exception" do
        response = stub(:success? => false, :body => {"message" => "Weird issue going on."})
        client.should_receive(:post).with("/api/lists/10/relationship", :data => {:action => "unfollow"}).and_return(response)
        list = Kippt::List.new(json_fixture("list.json"), client)

        expect {
          list.unfollow
        }.to raise_error(Kippt::APIError, "There was an error with the request: Weird issue going on.")
      end
    end
  end
end
