#
# 設定をフィルタリングするモジュール
#
module Eventaskbot
  module Handler
    module ConfigurableFilter

      #
      # フィルター
      #
      def self.filter(options)
        res = options
        raise "options :api not found."                                                  unless options.key?(:api)
        raise "options :api is NilClass."                                                if     options[:api].nil?
        raise "options :api[:name] is NilClass."                                         if     options[:api][:name].nil?
        raise "options api name #{options[:api][:name]} not found."                      unless api_exist?(options[:api][:name])
        raise "options response not found."                                              unless options.key?(:response)
        raise "options :response is NilClass."                                           if     options[:response].nil?
        raise "options :response[:format] is NilClass."                                  if     options[:response][:format].nil?
        raise "options responsep format name #{options[:response][:format]} not found."  unless format_exist?(options[:response][:format])
        res
      end

      #
      # フォーマット名が存在するか検索する
      # @param name[String] フォーマット
      # @return [Boolean] true 存在する | false 存在しない
      #
      def self.format_exist?(name)
        res = false

        get_format_types.each do |v|
          if name == v
            res = true
            break
          end
        end

        res
      end

      #
      # API名が存在するか検索する
      # @param name[String] API名
      # @return [Boolean] true 存在する | false 存在しない
      #
      def self.api_exist?(name)
        res = false

        get_api_name.each do |v|
          if name == v
            res = true
            break
          end
        end

        res
      end

      #
      # フォーマットタイプ一覧を返す
      # @return [Array] API名の一覧
      #
      def self.get_format_types
        ["json", "text", "hash"]
      end

      #
      # API名を返す
      # @return [Array] API名の一覧
      #
      def self.get_api_name
        ["init", "get-yam-token", "terget-set", "has-ticket"]
      end
    end
  end
end
