require "ostruct"

if RUBY_VERSION <= "1.8.7"
  OpenStruct.__send__(:define_method, :id) { @table[:id] }
end
