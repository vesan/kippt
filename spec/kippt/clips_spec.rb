require "spec_helper"
require "kippt/clips"

describe Kippt::Clips do
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  subject { client.clips }
  let(:base_uri) { "clips" }
  let(:singular_fixture) { "clip" }
  let(:collection_fixture) { "clips" }
  let(:collection_class) { Kippt::ClipCollection }
  let(:resource_class) { Kippt::Clip }

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

  describe "#feed" do
    subject { Kippt::Client.new(valid_user_credentials).clips }

    it "returns Clips" do
      feed = subject.feed
      expect(feed).to be_a Kippt::Clips
      expect(feed.base_uri).to eq "clips/feed"
    end
  end

  describe "#favorites" do
    subject { Kippt::Client.new(valid_user_credentials).clips }

    it "returns Clips" do
      feed = subject.favorites
      expect(feed).to be_a Kippt::Clips
      expect(feed.base_uri).to eq "clips/favorites"
    end
  end

  describe "#search" do
    subject { Kippt::Client.new(valid_user_credentials).clips }

    describe "parameters" do
      context "when parameter is a String" do
        it "does the search with the string being q" do
          stub_get("/search/clips?q=bunny").
            to_return(:status => 200, :body => fixture("clips.json"))
          subject.search("bunny")
        end
      end

      context "when parameter is a Hash" do
        context "with accepted keys" do
          it "does the search" do
            stub_get("/search/clips?q=bunny&list=4&is_starred=true").
              to_return(:status => 200, :body => fixture("clips.json"))
            subject.search(:q => "bunny", :list => 4, :is_starred => true)
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

    it "returns ClipCollection" do
      stub_get("/search/clips?q=bunny").
        to_return(:status => 200, :body => fixture("clips.json"))
      clips = subject.search("bunny")
      expect(clips).to be_a Kippt::ClipCollection
    end
  end

  describe "#save_resource" do
    subject { Kippt::Client.new(valid_user_credentials).clips }

    context "successful request" do
      it "returns hash with success boolean" do
       stub_post("/clips").
         with(:body => "{\"url\":\"http://kiskolabs.com\"}").
         to_return(:status => 200, :body => "{}", :headers => {})

        clip = Kippt::Clip.new(:url => "http://kiskolabs.com")
        response = subject.save_resource(clip)
        expect(response[:success]).to be_truthy
      end
    end

    context "unsuccessful request" do
      it "returns hash with success boolean and error message" do
       stub_post("/clips").
         with(:body => "{\"url\":\"http://kiskolabs.com\"}").
         to_return(:status => 400, :body => "{\"message\": \"No good.\"}", :headers => {})

        clip = Kippt::Clip.new(:url => "http://kiskolabs.com")
        response = subject.save_resource(clip)
        expect(response.success?).to be_falsey
        expect(response[:error_message]).to eq "No good."
      end
    end

    context "when object doesn't have an id" do
      it "POSTs new resource to the API" do
       stub_post("/clips").
         with(:body => "{\"url\":\"http://kiskolabs.com\"}").
         to_return(:status => 200, :body => "{}", :headers => {})

        clip = Kippt::Clip.new(:url => "http://kiskolabs.com")
        subject.save_resource(clip)
      end
    end
    
    context "when object has an id" do
      it "PUTs new version of the resource to the API" do
       stub_put("/clips/22").
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
       stub_delete("/clips/100").
         to_return(:status => 200, :headers => {})

        clip = Kippt::Clip.new(:id => 100)
        expect(subject.destroy_resource(clip)).to be_truthy
      end
    end
  end
end
