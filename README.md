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

## Usage

  - 默认是开启detail_parser的模式，可以通过配置文件来关闭

  ```ruby
  config.detail_parser.enabled = false
  ```

  - 默认的日志等级是 `:info`,可以通过配置文件修改

  ```ruby
  DetailParser.log_level = :debug
  ```

  - 默认是关闭了rails自身的Log输出

  ```ruby
  config.detail_parser.disable_action_view = true #关闭view的log
  config.detail_parser.disable_action_controller = true #关闭controller的log
  config.detail_parser.disable_active_record = true #关闭sql的log
  ```

  如需恢复所有的默认log输出，需添加下面的配置

  ```ruby
  config.detail_parser.keep_original_log = true
  ```

  - 默认的请求用户是开启的，但是内容被注释了．这个可以根据自己项目的情况修改．使用的时候去除注释就可以．

  ```ruby
  payload[:current_user] = "User Id #{current_user.id} | User name #{current_user.name}"
  ```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/detail_parser. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
