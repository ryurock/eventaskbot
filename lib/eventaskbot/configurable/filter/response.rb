#
# 設定をフィルタリングするモジュール
#
module Eventaskbot
  module Configurable
    module Filter
      module Response

        #
        # フィルター
        # @param options[Hash] 設定された値
        # @return [Hash] filterして追加、削除した値の設定値
        #
        def self.filter(opts)
          raise "options :response is NilClass."             if opts.nil?
          raise "options :response[:format] is NilClass."    if opts[:format].nil?

          opts[:format] = opts[:format].to_sym
          raise "options responsep format name #{opts[:format]} not found."  unless format_exist?(opts[:format])

        end

        #
        # フォーマット名が存在するか検索する
        # @param name[String] フォーマット
        # @return [Boolean] true 存在する | false 存在しない
        #
        def self.format_exist?(name)
          return false if format_types.index(name).nil?
          true
        end

        #
        # フォーマットタイプ一覧を返す
        # @return [Array] API名の一覧
        #
        def self.format_types
          [:json, :text, :hash]
        end
      end
    end
  end
end
