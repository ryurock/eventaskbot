module Eventaskbot
  module Configurable

    attr_accessor :options

    #
    # 設定をマージする
    #
    def self.configure(value)
    end

    #
    # 設定キー一覧を取得する
    #
    def self.keys
      @options.keys
    end

    #
    # 設定キーの値を取得する
    #
    def self.keys
      @options.keys
    end

    def self.reset
      @options = nil
    end
  end
end
