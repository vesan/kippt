require "spec_helper"
require "kippt/clips"

describe Kippt::Clips do
  subject { Kippt::Client.new(valid_user_credentials).clips }
  let(:base_uri) { "clips" }
  let(:singular_fixture) { "clip" }
  let(:collection_class) { Kippt::ClipCollection }
  let(:resource_class) { Kippt::Clip }

  it_behaves_like "collection resource"

  describe "#search" do
    subject { Kippt::Client.new(valid_user_credentials).clips }

    describe "parameters" do
      it "accepts String" do
        stub_get("/search/clips?q=bunny").
          to_return(:status => 200, :body => fixture("clips.json"))
        subject.search("bunny")
      end

      it "accepts Hash" do
        stub_get("/search/clips?q=bunny&list=4&is_starred=true").
          to_return(:status => 200, :body => fixture("clips.json"))
        subject.search(:q => "bunny", :list => 4, :is_starred => true)
      end
    end

    it "returns ClipCollection" do
      stub_get("/search/clips?q=bunny").
        to_return(:status => 200, :body => fixture("clips.json"))
      clips = subject.search("bunny")
      clips.is_a? Kippt::ClipCollection
    end
  end

  describe "#save_resource" do
    subject { Kippt::Client.new(valid_user_credentials).clips }

    context "successful request" do
      it "returns hash with success boolean" do
       stub_request(:post, "https://kippt.com/api/clips").
         with(:body => "{\"url\":\"http://kiskolabs.com\"}").
         to_return(:status => 200, :body => "{}", :headers => {})

        clip = Kippt::Clip.new(:url => "http://kiskolabs.com")
        response = subject.save_resource(clip)
        response[:success].should be_true
      end
    end

    context "unsuccessful request" do
      it "returns hash with success boolean and error message" do
       stub_request(:post, "https://kippt.com/api/clips").
         with(:body => "{\"url\":\"http://kiskolabs.com\"}").
         to_return(:status => 400, :body => "{\"message\": \"No good.\"}", :headers => {})

        clip = Kippt::Clip.new(:url => "http://kiskolabs.com")
        response = subject.save_resource(clip)
        response[:success].should be_false
        response[:error_message].should eq "No good."
      end
    end

    context "when object doesn't have an id" do
      it "POSTs new resource to the API" do
       stub_request(:post, "https://kippt.com/api/clips").
         with(:body => "{\"url\":\"http://kiskolabs.com\"}").
         to_return(:status => 200, :body => "{}", :headers => {})

        clip = Kippt::Clip.new(:url => "http://kiskolabs.com")
        subject.save_resource(clip)
      end
    end
    
    context "when object has an id" do
      it "PUTs new version of the resource to the API" do
       stub_request(:put, "https://kippt.com/api/clips/22").
         with(:body => "{\"url\":\"http://kiskolabs.com\"}").
         to_return(:status => 200, :body => "{}", :headers => {})

        clip = Kippt::Clip.new(:id => 22, :url => "http://kiskolabs.com")
        subject.save_resource(clip)
      end 
    end
  end

  describe "#destroy_resource" do
    subject { Kippt::Client.new(valid_user_credentials).clips }

    context "successful request" do
      it "returns boolean" do
       stub_request(:delete, "https://kippt.com/api/clips/100").
         to_return(:status => 200, :headers => {})

        clip = Kippt::Clip.new(id: 100)
        subject.destroy_resource(clip).should be_true
      end
    end
  end
end
