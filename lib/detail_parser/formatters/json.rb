require 'json'
module DetailParser
  module Formatters
    class Json
      def call(data)
        puts "这里需要输出的data是#{data}"
        ::JSON.dump(data)
      end
    end
  end
end
