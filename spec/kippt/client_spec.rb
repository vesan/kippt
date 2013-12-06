require "spec_helper"
require "kippt/client"

describe Kippt::Client do
  describe "#initialize" do
    context "when there is no username" do
      it "raises error" do
        expect {
          Kippt::Client.new(:password => "secret")
        }.to raise_error(ArgumentError, "username is required")
      end
    end

    context "when there is no password or token" do
      it "raises error" do
        expect {
          Kippt::Client.new(:username => "vesan")
        }.to raise_error(ArgumentError, "password or token is required")
      end
    end

    context "when there is unauthenticated parameter" do
      it "doesn't raise error" do
        expect {
          Kippt::Client.new(:unauthenticated => true)
        }.to_not raise_error
      end
    end

    context "when debug is set to true" do
      it "sets client to debug mode" do
        client = Kippt::Client.new(:unauthenticated => true, :debug => true)
        client.debug?.should be_true
      end
    end
  end

  context "#debug" do
    it "can be set and read" do
      client = Kippt::Client.new(:unauthenticated => true)
      client.debug?.should be_false
      client.debug = true
      client.debug?.should be_true
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

    describe "error handling" do
      context "when response status is 401" do
        it "raises Kippt::APIError with message received from the server" do
          stub_request(:get, "https://bob:secret@kippt.com/error_path").
            to_return(:status => 401, :body => "{\"message\": \"Something horrible.\"}")

          expect {
            subject.get("/error_path")
          }.to raise_error(Kippt::APIError, "Something horrible.")
        end
      end
    end
  end

  describe "#account" do
    subject { Kippt::Client.new(:username => "bob", :password => "secret") }

    it "returns a Kippt::User instance" do
      subject.should_receive(:get).with("account").and_return(
        stub :body => {}
      )
      account = subject.account
      account.should be_a(Kippt::User)
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

    it "returns a Kippt::RootClips instance" do
      clips = subject.clips
      clips.should be_a(Kippt::RootClips)
    end
  end

  describe "#users" do
    subject { Kippt::Client.new(:username => "bob", :password => "secret") }

    it "returns a Kippt::Users instance" do
      users = subject.users
      users.should be_a(Kippt::Users)
    end
  end

  describe "#resource_from_url" do
    subject { Kippt::Client.new(valid_user_credentials) }

    it "returns correct resource" do
      stub_get("/users/10").
        to_return(:status => 200, :body => fixture("user.json"))
      resource = subject.resource_from_url(Kippt::User, "/api/users/10")
      resource.should be_a(Kippt::User)
    end

    context "when passed URL is blank" do
      it "raises ArgumentError" do
        expect {
          subject.resource_from_url(stub, "")
        }.to raise_error(ArgumentError, "The parameter URL can't be blank")
        expect {
          subject.resource_from_url(stub, nil)
        }.to raise_error(ArgumentError, "The parameter URL can't be blank")
      end
    end
  end
end
