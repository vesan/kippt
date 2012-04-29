require "spec_helper"
require "crack/json"
require "kippt/clip_collection"

describe Kippt::ClipCollection do
  let(:data) { Crack::JSON.parse(fixture("clip.json").read) }
  subject { Kippt::Clip.new(data) }

  describe "attribute accessors" do
    it "delegates to attributes" do
      [:url_domain, :updated, :is_starred,
       :title, :url, :notes, :created, :list, :id,
       :resource_uri].each do |attribute_name|
          subject.send(attribute_name).should eq data[attribute_name.to_s]
       end
    end
  end

  describe "#save" do
    let(:collection_resource) { Kippt::Client.new(valid_user_credentials).clips }
    subject { Kippt::Clip.new({}, collection_resource) }

    context "with valid parameters" do
      it "sends POST request to server" do
        collection_resource.should_receive(:save_object).with(subject).and_return({})
        subject.url = "http://kiskolabs.com"
        subject.save
      end

      it "returns true" do
        collection_resource.stub(:save_object).and_return(
          {success: true})
        subject.save.should be_true
      end
    end

    context "with invalid parameters" do
      before do
        collection_resource.stub(:save_object).and_return({success: false, error_message: "No url."})
      end

      it "sets an error messages" do
        subject.save
        subject.errors.should eq ["No url."]
      end

      it "returns false" do
        subject.save.should be_false
      end

      it "clears previous errors" do
        subject.save
        subject.errors.should eq ["No url."]
        subject.save
        subject.errors.should eq ["No url."]
      end
    end
  end
end
