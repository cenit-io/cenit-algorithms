# Cenit Algorithms

Run algorithms retrieving their codes from Cenit.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cenit-algorithms'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cenit-algorithms

## Usage

Run some algorithms

```ruby
require 'cenit/algorithms'

Cenit::Algorithms('Number Theory').factorial(5)  # 120

Cenit::Algorithms('Number Theory').gcd(20, 15)   # 5
```

Checkout more shared algorithms at https://cenit.io/algorithms

Algorithms codes are loaded on demand and kept stored. If you want to reset your loaded algorithms then execute:

```ruby
Cenit::Algorithms.reset
```

If you want to run your own algorithms then configure your Cenit credentials:

```ruby
Cenit.access_token 'XXXXXXXXXX'
Cenit.access_key   'KKKKKKKKKK'
```
 
 If you want to use your own instance of Cenit then configure your host URL by:

```ruby
Cenit.host 'my-cenit-host-url'
```

Learn more about Cenit at https://cenit.io

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/cenit-io/cenit-algorithms/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
