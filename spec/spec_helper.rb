unless ENV["CI"] == "true"
  require "simplecov"
  SimpleCov.start
end

require "kippt"
require "rspec"
require "webmock/rspec"

Dir["./spec/shared_examples/*.rb"].each {|f| require f }

def stub_get(url)
  stub_request(:get, kippt_url(url))
end

def stub_post(url)
  stub_request(:post, kippt_url(url))
end

def stub_put(url)
  stub_request(:put, kippt_url(url))
end

def stub_delete(url)
  stub_request(:delete, kippt_url(url))
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

def json_fixture(file)
  MultiJson.load(fixture(file).read)
end
