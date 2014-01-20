# -*- coding: utf-8 -*-

require "uri"
require "yammer"

#
# Plugins Yammer Module
#
module Eventaskbot
  module Notifications
    module Yammer
      class GetOauthToken

        attr_accessor :client, :res, :prehook, :afterhook

        def initialize
          @res       = {:status => :fail, :message => ""}
        end

        #
        # 実行メソッド
        # @opts[Hash] パラメーターオプション
        # @return[Hash] レスポンス
        #
        def execute(opts)
          #配列の値をバリデート
          [:client_id, :client_secret, :access_token].each{ |v| return @res if validate opts, v }

          ::Yammer.configure do |c|
            c.client_id = opts[:client_id]
            c.client_secret = opts[:client_secret]
            c.access_token = opts[:access_token]
          end

          api_res = ::Yammer.all_groups

          unless api_res.code == 200
            @res[:message] = "[Failed] notification is failed. all_groups"
            @res[:status] = :fail
            return @res
          end

          api_res.body.each do |v|
            unless opts[:group][:yammer].index(v[:name].to_sym).nil?
              group_id = v[:id]
              ::Yammer.create_message("Yammerのトークン情報を最新に更新しました", { :group_id => group_id })
              break
            end
          end
        end

        #
        # パラメーターのバリデート
        # @param opts[Hash] バリデートしたい値
        # @param key[Symbol] バリデートしたいキー
        # @return true バリデートでブロックした | false バリデート通過
        #
        def validate(opts, key)
          unless opts.key? key
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
