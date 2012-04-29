require "spec_helper"
require "crack/json"
require "kippt/list"

describe Kippt::List do
  subject { Kippt::List.new(data, collection_resource) }
  let(:collection_resource) { Kippt::Client.new(valid_user_credentials).lists }

  let(:data) { Crack::JSON.parse(fixture("list.json").read) }
  let(:attributes) { 
    [:id, :rss_url, :updated, :title,
     :created, :slug, :resource_uri]
  }

  it_behaves_like "resource"
end
