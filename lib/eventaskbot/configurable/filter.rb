require 'eventaskbot/configurable/filter/api'
require 'eventaskbot/configurable/filter/service'
require 'eventaskbot/configurable/filter/notify'
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
      include Notify

      #
      # フィルター
      # @param options[Hash] 設定された値
      # @return [Hash] filterして追加、削除した値の設定値
      #
      def self.filter(options)

        raise "options :api not found."       unless options.key?(:api)
        raise "options :response not found."  unless options.key?(:response)

        options[:api] = Api.filter(options[:api])
        Eventaskbot.configure { |c| c.api = options[:api] }

        api_type = Eventaskbot.options[:api][:type]
        api_name = Eventaskbot.options[:api][:name].gsub(/-/,"_")

        api_type_opts = {}

        options[:service] = Service.filter

        api_type_opts           = Service.sub_conf_instance_get(api_type).options[api_name.to_sym]
        api_type_opts           = {} if api_type_opts.nil?
        api_type_opts[:service] = options[:service]

        options[:notify] = Notify.filter
        Eventaskbot.configure { |c| c.notify = options[:notify] }
        api_type_opts[:notify] = options[:notify]

        Service.sub_conf_instance_get(api_type).instance_variable_set("@#{api_name}", api_type_opts)

        options[:response] = Response.filter(options[:response])
        Eventaskbot.configure { |c| c.response = options[:response] }

        options
      end
    end
  end
end
