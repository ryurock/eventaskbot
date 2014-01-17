#
# 設定のServiceをフィルタリングするモジュール
#
module Eventaskbot
  module Configurable
    module Filter
      module Notify

        #
        # フィルター
        # @return [Hash] filterして追加、削除した値の設定値
        #
        def self.filter
          notify = {}

          opts = Eventaskbot.options

          notify = collect(notify, opts[:notify]) if option_exist?(opts, :notify)

          api_name = opts[:api][:name].gsub(/-/, "_").to_sym
          api_type = opts[:api][:type]

          sub_conf = sub_conf_instance_get(api_type)

          notify = collect(notify, sub_conf.options[api_name][:notify]) if option_exist?(sub_conf.options, api_name) && option_exist?(sub_conf.options[api_name], :notify)
          notify = collect(notify, opts[:api][:params][:notify]) if option_exist?(opts[:api][:params], :notify)

          return notify unless notify.key?(:service)

          #両方ともhookの設定がない場合は両方とも通知される
          if notify.key?(:prehook) == false && notify.key?(:afterhook) == false
            notify[:prehook]   = true
            notify[:afterhook] = true
          else
            notify[:prehook]   = false unless notify.key?(:prehook)
            notify[:afterhook] = false unless notify.key?(:afterhook)
          end

          services = {}

          notify[:service].each do |v|
            klass_name = api_name.to_s.split("_").map(&:capitalize).join("")
            require "eventaskbot/notifications/#{v}/#{api_name}"

            klass           = eval("Eventaskbot::Notifications::#{v.to_s.capitalize}::#{klass_name}.new")
            klass.prehook   = notify[:prehook]
            klass.afterhook = notify[:afterhook]

            services[v] = klass
          end

          notify[:klass] = services
          notify
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
        # @param notify[Hash] マージする元
        # @param params[Hash] マージしたい値
        # @return [Hash] マージした値
        #
        def self.collect(notify, params)
          return notify.merge(params) if notify.empty?

          params.inject(notify) do |h,(k,v)|
            h[k] = v
            h
          end
        end
      end
    end
  end
end
