require 'eventaskbot/storage/driver'

#
# プラグインを管理するモジュール
#
module Eventaskbot
  module Storage

    #
    # ストレージを取得
    #
    def self.driver(opts = {})
      opts = Eventaskbot.options if opts.empty?
      driver = Eventaskbot::Storage::Driver.set(opts[:storage][:driver]) if opts[:storage].key?(:driver)
      driver
    end

  end
end
