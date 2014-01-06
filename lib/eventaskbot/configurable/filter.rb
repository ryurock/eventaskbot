require 'eventaskbot/configurable/filter/api'
require 'eventaskbot/configurable/filter/service'
require 'eventaskbot/configurable/filter/response'

#
# 設定をフィルタリングするモジュール
#
module Eventaskbot
  module Configurable
    module Filter

      include Api
      include Service
      include Response

      #
      # フィルター
      # @param options[Hash] 設定された値
      # @return [Hash] filterして追加、削除した値の設定値
      #
      def self.filter(options)

        raise "options :api not found."       unless options.key?(:api)
        raise "options :response not found."  unless options.key?(:response)

        options[:api]      = Api.filter(options[:api])
        options[:response] = Response.filter(options[:response])

        options
      end
    end
  end
end
