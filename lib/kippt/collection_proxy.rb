module Kippt::Resource
  private

  def validate_collection_options(options)
    options.each do |key, _|
      unless [:limit, :offset].include?(key)
        raise ArgumentError.new("Unrecognized argument: #{key}")
      end
    end
  end
end
