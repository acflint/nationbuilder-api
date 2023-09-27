[![Gem Version](https://badge.fury.io/rb/nationbuilder-api.svg)](https://badge.fury.io/rb/nationbuilder-api)

# NationBuilder API Client

A simple, flexible NationBuilder API client that is compatible with V1 and V2 APIs, using the OAuth2 authentication and refresh flows, and respects the "retry-after" rate limiting headers.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add nationbuilder-api

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install nationbuilder-api

## Usage

The gem expects that you have a "nation" object that has attributes for `slug`, `token`, `refresh_token`, `token_expires_at`. This could be an ActiveModel object, or a simple hash.

```ruby
nation = {slug: "my-nation"
token: "1234abcd"
refresh_token: "0987abc"
token_expires_at: 12344567}

# Create a client
client = NationBuilder::Client.new(nation)

# Make API request
response = client.call(:get, "/api/v1/people")
# or
response = client.call(:put, "/api/v1/people/2", {person: {first_name: "Alex"}})
```

## Todo

Still need to implement token refreshing.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/acflint/nationbuilder-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/acflint/nationbuilder-api/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the NationBuilder project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/acflint/nationbuilder-api/blob/main/CODE_OF_CONDUCT.md).
