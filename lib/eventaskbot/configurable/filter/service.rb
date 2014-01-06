require 'eventaskbot/configurable/filter/api'

#
# 設定のServiceをフィルタリングするモジュール
#
module Eventaskbot
  module Configurable
    module Filter
      module Service
        include Filter::Api

        #
        # フィルター
        # @param options[Hash] 設定された値
        # @return [Hash] filterして追加、削除した値の設定値
        #
        def self.filter(opts)
          api_name = opts[:api][:name].gsub(/-/, "-")
          api_type = opts[:api][:type]

          opts_service = {}

          if opts.key?(:service) && opts[:service].nil? == false
            opts_service = opts[:service]
          end

          sub_opts = eval "Eventaskbot::Api::#{api_type.to_s.capitalize}.options"

          if sub_opts.nil? == false && sub_opts.key?(api_name)
            if sub_opts[api_name].nil? == false && sub_opts[api_name].key?(:service)
            end
          end
        end

      end
    end
  end
end
