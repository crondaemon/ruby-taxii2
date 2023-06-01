require 'hashie'
require 'nokogiri'
require 'rest-client'
require 'uri'
require 'nori'
require 'gyoku'
require 'json'

require 'taxii/version'
require 'taxii/time_extensions'
require 'taxii/messages'
require 'taxii/messages/parameters'
require 'taxii/messages/discovery_request'
require 'taxii/messages/poll_request'
require 'taxii/messages/poll_fulfillment_request'
require 'taxii/messages/feed_information_request'
require 'taxii/messages/collection_information_request'
require 'taxii/messages/content_block'
require 'taxii/client'
require 'taxii/poll_client'

module Taxii
  def self.configure(config: File.join(ENV['HOME'],'.taxii.json'), client: PollClient)
    configuration = JSON.parse(File.read(config))
    client.new(configuration)
  end

  def self.hail
    PollClient.new(user: 'guest', pass: 'guest', url: 'http://hailataxii.com/taxii-discovery-service')
  end

  def self.yeti
    PollClient.new(user: 'guest', pass: 'guest', url: 'http://taxiitest.mitre.org/services/discovery/')
  end

end
