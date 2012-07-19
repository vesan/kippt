require "spec_helper"
require "kippt/client"

describe Kippt::Client do
  describe "#initialize" do
    context "when there is no username" do
      it "raises error" do
        lambda {
          Kippt::Client.new(:password => "secret")
        }.should raise_error(ArgumentError, "username is required")
      end
    end

    context "when there is no password or token" do
      it "raises error" do
        lambda {
          Kippt::Client.new(:username => "vesan")
        }.should raise_error(ArgumentError, "password or token is required")
      end
    end
  end

  describe "connection" do
    subject { Kippt::Client.new(:username => "bob", :password => "secret") }

    describe "default headers" do
      it "includes correct mime-type and user-agent" do
        stub_request(:get, "https://kippt.com/foobar").
         with(:headers => {'Accept'=>'*/*', 'Content-Type'=>'application/vnd.kippt.20120429+json', 'User-Agent'=>"KipptRubyGem #{Kippt::VERSION},vesa@vesavanska.com,https://github.com/vesan/kippt", 'X-Kippt-Client'=>"KipptRubyGem #{Kippt::VERSION},vesa@vesavanska.com,https://github.com/vesan/kippt"})
        subject.get("/foobar")
      end
    end

    describe "error handling" do
      context "when response status is 401" do
        it "raises Kippt::APIError with message received from the server" do
          stub_request(:get, "https://kippt.com/error_path").
            to_return(:status => 401, :body => "{\"message\": \"Something horrible.\"}")

          lambda {
            subject.get("/error_path")
          }.should raise_error(Kippt::APIError, "Something horrible.")
        end
      end
    end
  end

  describe "#account" do
    subject { Kippt::Client.new(:username => "bob", :password => "secret") }

    it "returns a Kippt::Account instance" do
      subject.should_receive(:get).with("account").and_return(
        stub :body => {}
      )
      account = subject.account
      account.should be_a(Kippt::Account)
    end
  end

  describe "#lists" do
    subject { Kippt::Client.new(:username => "bob", :password => "secret") }

    it "returns a Kippt::Lists instance" do
      lists = subject.lists
      lists.should be_a(Kippt::Lists)
    end
  end

  describe "#clips" do
    subject { Kippt::Client.new(:username => "bob", :password => "secret") }

    it "returns a Kippt::Clips instance" do
      clips = subject.clips
      clips.should be_a(Kippt::Clips)
    end
  end
end
