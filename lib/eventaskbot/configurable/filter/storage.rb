#
# 設定のServiceをフィルタリングするモジュール
#
module Eventaskbot
  module Configurable
    module Filter
      module Storage

        #
        # フィルター
        # @return [Hash] filterして追加、削除した値の設定値
        #
        def self.filter
          storage = {}

          opts = Eventaskbot.options

          storage = collect(storage, opts[:storage]) if option_exist?(opts, :storage)

          api_name = opts[:api][:name].gsub(/-/, "_").to_sym
          api_type = opts[:api][:type]

          sub_conf = sub_conf_instance_get(api_type)

          storage = collect(storage, sub_conf.options[api_name][:storage]) if option_exist?(sub_conf.options, api_name) && option_exist?(sub_conf.options[api_name], :storage)
          storage = collect(storage, opts[:api][:params][:storage]) if option_exist?(opts[:api][:params], :storage)

          storage
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
        # ストレージの値をマージする
        # @param storage[Hash] マージする元
        # @param params[Hash] マージしたい値
        # @return [Hash] マージした値
        #
        def self.collect(storage, params)
          return storage.merge(params) if storage.empty?

          params.inject(storage) do |h,(k,v)|
            h[k] = v
            h
          end
        end
      end
    end
  end
end
