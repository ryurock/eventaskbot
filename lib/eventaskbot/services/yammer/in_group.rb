require "uri"
require "yammer"
require "mechanize"
require 'redis'
require 'hiredis'
require 'terminal-table'

require 'eventaskbot/services/yammer'

#
# Service Layer Yammer Group Import Module
#
module Eventaskbot
  module Services
    module Yammer
      class InGroup

        attr_accessor :client, :res, :code

        def initialize
          @res    = {:status => :fail, :message => ""}
        end

        #
        # 実行メソッド
        # @opts[Hash] パラメーターオプション
        # @return[Hash] レスポンス
        #
        def execute(opts)
          #pp opts
          #配列の値をバリデート
          [:group].each{ |v| return @res if validate opts, v }


          @res = {
            :status  => :ok,
            :message => "",#message,
            :response => json[:access_token][:token]
          }
        end

        #
        # パラメーターのバリデート
        # @param opts[Hash] バリデートしたい値
        # @param key[Symbol] バリデートしたいキー
        # @return true バリデートでブロックした | false バリデート通過
        #
        def validate(opts, key)
          if opts.nil? || opts.key?(key) == false
            @res[:message] = "[Failed] parametor or EventaskbotFile Setting #{key} => #{key} is not found"
            @res[:status] = :fail
            return true
          end
          @res[:status] = :ok
          false
        end
      end
    end
  end
end
