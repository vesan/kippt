module Kippt::Helpers
  private

  def assert_valid_keys(hash, *valid_keys)
    valid_keys.flatten!
    hash.each_key do |k|
      raise ArgumentError.new("Unrecognized argument: #{k}") unless valid_keys.include?(k)
    end
  end

  def symbolize_keys! hash
    hash.keys.each do |key|
      hash[(key.to_sym rescue key) || key] = hash.delete(key)
    end
    hash
  end
end
