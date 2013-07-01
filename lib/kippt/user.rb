require "kippt/users"
require "kippt/followers"
require "kippt/following"
require "kippt/follow_relationship"
require "kippt/user_clips"
require "kippt/user_lists"

class Kippt::User
  include Kippt::Resource

  attributes :username, :bio, :app_url, :avatar_url, :twitter,
             :id, :github, :website_url, :full_name, :dribble,
             :counts, :resource_uri, :api_token

  boolean_attributes :is_pro

  alias_method :token, :api_token

  def collection_resource_class
    Kippt::Users
  end

  def lists
    Kippt::UserLists.new(client, self)
  end

  def clips
    Kippt::UserClips.new(client, self)
  end

  def followers
    Kippt::Followers.new(client, self)
  end

  def following
    Kippt::Following.new(client, self)
  end

  # Tells if authenticated user is following the user.
  def following?
    Kippt::FollowRelationship.new(client, self).following?
  end

  def follower_count
    counts["follows"]
  end

  def following_count
    counts["followed_by"]
  end

  def follow
    Kippt::FollowRelationship.new(client, self).follow
  end

  def unfollow
    Kippt::FollowRelationship.new(client, self).unfollow
  end
end
