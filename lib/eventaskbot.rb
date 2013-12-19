require "eventaskbot/version"
require "eventaskbot/configurable"

module Eventaskbot
  include Configurable

  #
  # 設定を与える
  # @return [Eventaskbot]
  #
  def self.configure
    yield Eventaskbot::Configurable if block_given?
    self
  end
end
