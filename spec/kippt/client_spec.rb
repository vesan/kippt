require "spec_helper"
require "kippt/client"

describe Kippt::Client do
  describe "#initialize" do
    context "when there is no username" do
      it "raises error"
    end

    context "when there is no password or token" do
      it "raises error"
    end
  end

  describe "connection" do
    subject { Kippt::Client.new(:username => "bob", :password => "secret") }

    describe "default headers" do
      it "includes correct mime-type and user-agent" do
        stub_request(:get, "https://bob:secret@kippt.com/foobar").
         with(:headers => {'Accept'=>'*/*', 'Content-Type'=>'application/vnd.kippt.20120429+json', 'User-Agent'=>"KipptRubyGem #{Kippt::VERSION},vesa@vesavanska.com,https://github.com/vesan/kippt", 'X-Kippt-Client'=>"KipptRubyGem #{Kippt::VERSION},vesa@vesavanska.com,https://github.com/vesan/kippt"})
        subject.get("/foobar")
      end
    end
  end

  describe "#lists" do
  end
end
