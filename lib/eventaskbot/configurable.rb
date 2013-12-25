require 'eventaskbot/configurable/merge'

#
# 設定を扱うモジュール
#
module Eventaskbot
  module Configurable

    include Merge

    attr_accessor :plugin_dir, :storage, :service, :response

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
    # 設定キー一覧を取得する
    #
    def keys
      instance_variables.inject([]) do |a,var|
        k = var.to_s.tr('@','').to_sym
        a.push(k)
      end
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
