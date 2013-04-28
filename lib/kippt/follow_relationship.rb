class Kippt::FollowRelationship
  attr_reader :user

  def initialize(client, user)
    @client = client
    @user   = user
  end

  def following?
    response = client.get("users/#{user.id}/relationship/")

    if response.success?
      response.body["following"]
    else
      raise Kippt::APIError.new("Resource could not be loaded: #{response.body["message"]}")
    end
  end

  private

  def client
    @client
  end
end
