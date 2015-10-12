require 'hashie'
require 'nokogiri'
require 'rest-client'
require 'uri'
require 'nori'
require 'gyoku'

require 'taxii/version'
require 'taxii/time_extensions'
require 'taxii/message'
require 'taxii/client'
require 'taxii/poll_client'
require 'taxii/messages/poll_request'

module Taxii
  def self.configure(config: File.join(ENV['HOME'],'.taxii.json'), client: PollClient)
    configuration = JSON.parse(File.read(config))
    client.new(configuration)
  end

end
