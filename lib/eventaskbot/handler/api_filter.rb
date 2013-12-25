#
# 設定をフィルタリングするモジュール
#
module Eventaskbot
  module Handler
    module ApiFilter

      #
      # フィルター
      # @param options[Hash] 設定された値
      # @return [Hash] filterして追加、削除した値の設定値
      #
      def self.filter(opts)
        raise "options :api is NilClass."           if     opts.nil?
        raise "options :api[:name] is NilClass."    if     opts[:name].nil?

        opts[:name] = opts[:name].to_s
        raise "options api name #{opts[:name]} not found."  unless api_exist?(opts[:name])

        opts[:type] = :collector unless get_collectors.index(opts[:name]).nil?
        opts[:type] = :etc       unless get_etc.index(opts[:name]).nil?

        opts
      end

      #
      # API名が存在するか検索する
      # @param name[String] API名
      # @return [Boolean] true 存在する | false 存在しない
      #
      def self.api_exist?(name)
        res = false

        get_collectors.each do |v|
          if name == v
            res = true
            break
          end
        end

        get_etc.each do |v|
          if name == v
            res = true
            break
          end
        end

        res
      end

      #
      # Collector APi一覧を返す
      # @return [Array] Collector API名の一覧
      #
      def self.get_collectors
        ["terget-set", "has-ticket"]
      end

      #
      # Etc APi一覧を返す
      # @return [Array] Etc API名の一覧
      #
      def self.get_etc
        ["init", "get-oauth-token"]
      end
    end
  end
end
