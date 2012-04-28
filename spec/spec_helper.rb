require "kippt"
require "rspec"
require "webmock/rspec"

def stub_get(url)
  stub_request(:get, kippt_url(url))
end

def kippt_url(url)
  "https://kippt.com/api#{url}"
end

def valid_user_credentials
  {:username => "bob", :token => "bobstoken"}
end

def fixture(file)
  fixture_path = File.expand_path("../fixtures", __FILE__)
  File.new(fixture_path + '/' + file)
end

shared_examples_for "collection" do
  describe "#total_count" do
    it "returns total count of lists" do
      subject.total_count.should eq data["meta"]["total_count"]
    end
  end

  describe "#offset" do
    it "returns offset of the results" do
      subject.offset.should eq 0
    end
  end

  describe "#limit" do
    it "returns limit of the results" do
      subject.limit.should eq 20
    end
  end
end
