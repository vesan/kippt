class Kippt::UserCollection
  include Kippt::Collection

  def object_class
    Kippt::User
  end

  def collection_resource_class
    Kippt::Users
  end
end
