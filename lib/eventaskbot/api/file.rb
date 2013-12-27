#
# File API Base
#
module Eventaskbot
  module Api
    module File
      class << self

        attr_accessor :init

        #
        # 設定をマージする
        #
        def configure
          yield self if block_given?
        end

        #
        # 設定を取得する
        #
        def options
          value = {}

          instance_variables.each do |var|
            k = var.to_s.tr('@','')
            value[k.to_sym] = instance_variable_get(var)
            value = value.merge(value)
          end

          value
        end

        #
        # 設定の初期化を行う
        #
        def reset
          instance_variables.each do |var|
            instance_variable_set(var, nil)
          end
        end

      end
    end
  end
end
