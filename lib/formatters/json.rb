require 'json'
module DetailParser
  module Formatters
    class Json
      def call(data)
        ::JSON.dump(data)
      end
    end
  end
end
