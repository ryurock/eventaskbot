require 'eventaskbot/storage/driver'

#
# プラグインを管理するモジュール
#
module Eventaskbot
  module Storage

    #
    # ストレージを取得
    # @param opts[Hash] ストレージの設定
    # @return Eventaskbot::Storage
    #
    def self.register_driver(opts = {})
      opts = Eventaskbot.options[:storage] if opts.empty?
      Eventaskbot::Storage::Driver.set(opts[:driver]) if opts.key?(:driver)
      self
    end

    #
    # ストレージドライバーを取得
    # @return Eventaskbot::Storage::Driver
    #
    def self.driver
      Eventaskbot::Storage::Driver.get
    end

    #
    # ストレージに保存
    # @param key[String] 保存したいキー名
    # @param value[mixIn} 保存したい値
    # @return Boolean true 保存に成功 | false 保存に失敗
    #
    def self.set(key, value)
     return true if self.driver.set(key, value) == "OK"
     false
    end

  end
end
