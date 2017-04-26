module DetailParser
	module Generators
		class InstallGenerator < Rails::Generators::Base
			source_root File.expand_path("../templates", __FILE__)

			def copy_initializer
        template "detail_parser.rb", "config/initializers/detail_parser.rb"
			end

		end
	end
end
