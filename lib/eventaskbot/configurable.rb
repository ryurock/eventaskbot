module Eventaskbot
  module Configurable

    attr_accessor :plugin_dir, :storage, :service

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
      res = []
      value = {}

      instance_variables.each do |var|
        k = var.to_s.tr('@','')
        value[k.to_sym] = instance_variable_get(var)
        res.push(value)
      end

      res
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
    # 設定キーの値を取得する
    #
    def key(name)
      self.instance_eval("@" << name.to_s)
    end

    def reset
      instance_variables.each do |var|
        instance_variable_set(var, nil)
      end
    end
  end
end
