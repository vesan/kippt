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

  def follow
    response = update_following(true)

    if response.success?
      true
    else
      raise Kippt::APIError.new("Problem with following: #{response.body["message"]}")
    end
  end

  def unfollow
    response = update_following(false)

    if response.success?
      true
    else
      raise Kippt::APIError.new("Problem with unfollowing: #{response.body["message"]}")
    end
  end

  private

  def update_following(value)
    follow_value = value ? "follow" : "unfollow"

    client.post("users/#{user.id}/relationship/", :data => {:action => follow_value})
  end

  def client
    @client
  end
end
