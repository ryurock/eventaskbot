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
        # @return [Hash] filterして追加、削除した値の設定値
        #
        def self.filter
          service, opts_service, sub_conf_service, api_params_service = {}

          opts = Eventaskbot.options

          if option_exist?(opts, :service)
            opts_service = opts[:service]
            service = collect(service, opts_service)
          end

          api_name = opts[:api][:name].gsub(/-/, "_").to_sym
          api_type = opts[:api][:type]

          sub_conf = sub_conf_instance_get(api_type)

          if option_exist?(sub_conf.options, api_name) && option_exist?(sub_conf.options[api_name], :service)
              sub_conf_service = sub_conf.options[api_name][:service]

              service = collect(service, sub_conf_service)
          end

          if option_exist?(opts[:api][:params], :service)
            api_params_service = opts[:api][:params][:service]
            service = collect(service, api_params_service)
          end

          use_service = []

          use_service = opts[:use_service]                       if option_exist?(opts, :use_service)
          use_service = sub_conf.options[api_name][:use_service] if option_exist?(sub_conf.options, api_name) && option_exist?(sub_conf.options[api_name], :use_service)
          use_service = opts[:api][:params][:use_service]        if option_exist?(opts[:api][:params], :use_service)

          service.inject({}) do | h,(k,v) |
            h[k] = v
            klass_name = api_name.to_s.split("_").map(&:capitalize).join("")
            h[k][:klass] = "Eventaskbot::Services::#{k.capitalize}::#{klass_name}"
            h
          end

          return service if use_service.empty?

          service = service.inject({}) do |h, (k,v)|
            h[k] = v unless use_service.index(k).nil?
            h
          end

          service
        end

        def collect_service(opts)
        end

        #
        # optionの値が存在するか
        # @param opts[Hash] 検証したい値
        # @param key[Symbol] 検証したい値のキー
        # @return [Boolean] 存在する true | 存在しない false
        #
        def self.option_exist?(opts, key)
          return false if opts.key?(key) == false || opts[key].nil?
          true
        end

        #
        # sub設定のオブジェクトを呼び出す
        # @param api_type[Symbol] api種別
        # @return [Object] API種別に応じたオブジェクト
        #
        def self.sub_conf_instance_get(api_type)
          eval "Eventaskbot::Api::#{api_type.to_s.capitalize}"
        end

        #
        # サービスの値をマージする
        # @param service[Hash] マージする元
        # @param params[Hash] マージしたい値
        # @return [Hash] マージした値
        #
        def self.collect(service, params)
          return service.merge(params) if service.empty?

          params.inject(service) do |h,(k,v)|
            if service.key?(k)
              h[k] =  h[k].merge(v)
            else
              h[k] = v
            end

            h
          end
        end
      end
    end
  end
end
