require "spec_helper"
require "kippt/list"

describe Kippt::List do
  subject { Kippt::List.new(data, client) }
  let(:client) { Kippt::Client.new(valid_user_credentials) }
  let(:collection_resource_class) { Kippt::Lists }

  let(:data) { MultiJson.load(fixture("list.json").read) }
  let(:attributes) {
    [:id, :rss_url, :updated, :title,
     :created, :slug, :resource_uri]
  }

  it_behaves_like "resource"

  describe "#private?" do
    it "gets data from is_private" do
      list = Kippt::List.new({:is_private => true}, nil)
      list.private?.should be_true
    end
  end
end
