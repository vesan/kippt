require_relative "clips"

class Kippt::UserClips < Kippt::Clips
  attr_reader :user

  def self.valid_filter_parameters
    [:limit, :offset]
  end

  def initialize(client, user)
    @user = user

    super(client, "users/#{user.id}/clips")
  end

  def favorites
    Kippt::Clips.new(client, "#{base_uri}/favorites")
  end

  def likes
    Kippt::Clips.new(client, "#{base_uri}/likes")
  end
end
