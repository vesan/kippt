require_relative "comment"

class Kippt::CommentCollection
  include Kippt::Collection

  def object_class
    Kippt::Comment
  end
end
