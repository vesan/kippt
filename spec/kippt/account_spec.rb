require "spec_helper"
require "kippt/account"

describe Kippt::Account do
  describe "#token" do
    subject { Kippt::Account.new("api_token" => "12345") }

    it "gets set" do
      subject.token.should eq "12345"
    end
  end

  describe "#api_token" do
    subject { Kippt::Account.new("api_token" => "12345") }

    it "is aliased to token" do
      subject.api_token.should eq "12345"
    end
  end

  describe "#username" do
    subject { Kippt::Account.new("username" => "bob") }

    it "gets set" do
      subject.username.should eq "bob"
    end
  end
end
