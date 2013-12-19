module Eventaskbot
  module Configurable

    attr_accessor :plugins, :storage, :service

    #
    # 設定をマージする
    #
    def self.configure
      yield self if block_given?
      self
    end

    #
    # 設定を取得する
    #
    def self.options
      @options.keys
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
