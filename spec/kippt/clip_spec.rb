require "spec_helper"
require "crack/json"
require "kippt/clip"

describe Kippt::Clip do
  subject { Kippt::Clip.new(data, collection_resource) }
  let(:collection_resource) { Kippt::Client.new(valid_user_credentials).clips }

  let(:data) { Crack::JSON.parse(fixture("clip.json").read) }
  let(:attributes) {
    [:url_domain, :updated, :is_starred, :title,
     :url, :notes, :created, :list, :id, :resource_uri]
   }

  it_behaves_like "resource"
end
