require 'eventaskbot/configurable/filter/api'

#
# 設定をフィルタリングするモジュール
#
module Eventaskbot
  module Configurable
    module Filter

      include Api

      #
      # フィルター
      # @param options[Hash] 設定された値
      # @return [Hash] filterして追加、削除した値の設定値
      #
      def self.filter(options)

        raise "options :api not found."       unless options.key?(:api)
        raise "options :response not found."  unless options.key?(:response)

        #optiosnに追加したい値をinjectする
        options = options.inject({}) do |a, (k,v)|
           a[k] = v
           a[k] = Api.filter(v) if k == :api

           if k == :response

             raise "options :response is NilClass."             if     v.nil?
             raise "options :response[:format] is NilClass."    if     v[:format].nil?

             a[k][:format] = v[:format].to_sym
             raise "options responsep format name #{v[:format]} not found."  unless format_exist?(a[k][:format])
           end

           a
        end

        options
      end

      #
      # フォーマット名が存在するか検索する
      # @param name[String] フォーマット
      # @return [Boolean] true 存在する | false 存在しない
      #
      def self.format_exist?(name)
        get_format_types.each{ |v| return true if name == v }
        false
      end

      #
      # フォーマットタイプ一覧を返す
      # @return [Array] API名の一覧
      #
      def self.get_format_types
        [:json, :text, :hash]
      end
    end
  end
end
