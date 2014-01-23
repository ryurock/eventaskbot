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

    #
    # ストレージからデータを取得
    # @param key[String] 取得したいキー名
    # @return [Mixin] ストレージのデータ
    #
    def self.get(key)
     self.driver.get(key)
    end

    #
    # 通知スレッドグループIDをストレージから取得する
    # @param service_name[String] サービス名
    # @param key[Symbol] 取得したいグループ名
    # @return [Symbol] ストレージのデータ
    #
    def self.find_notify_thread_group_id(service_name, group)
     self.driver.get("notify_thread_id_#{service_name.to_s}_#{group.to_s}")
    end

    #
    # ストレージからデータを削除
    # @param key[String] 削除したいキー名
    # @return Boolean true 削除に成功 | false 削除に失敗
    #
    def self.del(key)
     self.driver.del(key)
    end
  end
end
