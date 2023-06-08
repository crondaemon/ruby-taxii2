# Ruby::Taxii

Ruby TAXII client

Currently under development - likely to break at a moment's notice.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby-taxii2'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-taxii2

## Usage

```ruby
require 'taxii'

# You can use a json file configuration
# client = Taxii::configure(config: 'my.config.json')
# or a direct configuration
client = Taxii::configure(user: 'user', pass: 'pass', url: 'url', logger: Logger.new(STDOUT))
collections = client.discover_collections

# List collections (name, type and availability)
puts "Listing collections:"
collections.each do |collection|
  puts "#{collection['@collection_name']} #{collection['@collection_type']} #{collection['@available']}"
end

# Pick up the first available collection
collection_name = collections.find{ |collection| collection['@available'] == 'true' }['@collection_name']

puts "Retrieving data for collection: #{collection_name}"
poll_request_message = Taxii::Messages::PollRequest.new(
  collection_name: collection_name,
  poll_parameters: Taxii::Messages::Parameters::Poll.new(response_type: 'FULL')
)

client.get_content_blocks(poll_request_message).each do |message|
  message = Taxii.parse(body)
  puts "Received a #{message.class}"
  puts message.as_json if message.is_a?(Taxii::Messages::ContentBlock)
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/crondaemon/ruby-taxii2.
