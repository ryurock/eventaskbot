require "eventaskbot/version"
require "eventaskbot/configurable"
require "eventaskbot/handler"

module Eventaskbot
  class << self
    include Configurable
    include Handler
  end
end
