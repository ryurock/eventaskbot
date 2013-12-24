require "eventaskbot/version"
require "eventaskbot/configurable"

module Eventaskbot
  class << self
    include Configurable
  end
end
