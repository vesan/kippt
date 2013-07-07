require "kippt/collection"
require "kippt/comment"

class Kippt::CommentCollection
  include Kippt::Collection

  def object_class
    Kippt::Comment
  end
end
