# DetailParser

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/detail_parser`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'detail_parser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install detail_parser

Next to config, To run

    $ rails g detail_parser:install

That will create file in `config/initializers/detail_parser.rb`

It Looks like
    ```ruby
      Rails.application.configure do
        config.detail_parser.enabled = true
        config.detail_parser.current_user = true
      end


      ActionController::Instrumentation.class_eval do
        def process_action(*args)
          raw_payload = {
            controller: self.class.name,
            action:     self.action_name,
            params:     request.filtered_parameters,
            format:     request.format.try(:ref),
            method:     request.method,
            path:       (request.fullpath rescue "unknown"),
            request:    request,
            response:   response,
            session:    session
          }

          ActiveSupport::Notifications.instrument("start_processing.action_controller", raw_payload.dup)

          ActiveSupport::Notifications.instrument("process_action.action_controller", raw_payload) do |payload|
            result = super
            payload[:status] = response.status
            # payload[:current_user] = "User Id #{current_user.id} | User name #{current_user.name}"
            append_info_to_payload(payload)
            result
          end
        end
      end

    ```

## Usage



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/detail_parser. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
