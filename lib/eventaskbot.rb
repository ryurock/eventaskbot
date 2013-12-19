require "eventaskbot/version"
require "eventaskbot/configurable"

module Eventaskbot
  include Configurable

  #
  # 設定を与える
  # @return [Eventaskbot]
  #
  def self.configure(value)
    Eventaskbot::Configurable.configure(value)
    self
  end
end
