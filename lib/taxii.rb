require 'hashie'
require 'nokogiri'
require 'rest-client'
require 'uri'
require 'nori'
require 'gyoku'

require 'taxii/version'
require 'taxii/time_extensions'
require 'taxii/messages'
require 'taxii/messages/parameters'
require 'taxii/messages/discovery_request'
require 'taxii/messages/poll_request'
require 'taxii/messages/feed_information_request'
require 'taxii/client'
require 'taxii/poll_client'

module Taxii
  def self.configure(config: File.join(ENV['HOME'],'.taxii.json'), client: PollClient)
    configuration = JSON.parse(File.read(config))
    client.new(configuration)
  end

end
