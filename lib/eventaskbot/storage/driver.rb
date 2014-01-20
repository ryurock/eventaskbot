require 'redis'
require 'hiredis'
#
# ストレージドライバーモジュール
#
module Eventaskbot
  module Storage
    module Driver

      attr_reader :client

      #
      # ストレージを取得
      #
      def self.set(driver)
        @client = driver
        self
      end

      #
      # プラグインがgemに存在するか検索する
      #
      def self.get
        @client
      end
    end
  end
end
