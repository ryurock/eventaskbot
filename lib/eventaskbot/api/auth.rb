#
# Auth API Base
#
module Eventaskbot
  module Api
    module Auth
      class << self

        attr_accessor :get_oauth_token

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
          instance_variables.inject({}) do |a,var|
            k = var.to_s.tr('@','')
            a[k.to_sym] = instance_variable_get(var)
             a.merge(a)
          end
        end

        #
        # 設定をインスタンス変数単位で取得する
        # @param name[Symbol] 取得したいインスタンス変数
        # @return nil | Mix 設定の値
        #
        def option(name)
          opts = options

          return nil if opts.nil? || opts.key?(name) == false

          opts[name]
        end

        #
        # 設定の初期化を行う
        #
        def reset
          instance_variables.each{ |var| instance_variable_set(var, nil) }
        end

      end
    end
  end
end
