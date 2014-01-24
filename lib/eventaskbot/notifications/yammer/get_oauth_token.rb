# -*- coding: utf-8 -*-

require "uri"
require "yammer"
require "eventaskbot/notifications/yammer/create_thread"

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
          @client = ::Yammer::Client.new(:access_token => opts[:access_token]) if @client.nil?

          params  = {}

          if opts.key?(:thread_id)
            params[:replied_to_id] = opts[:thread_id]
            @client.create_message("Yammerのトークン情報を最新に更新しました", params)
            @res[:message] = "[Success] notification is API get-oauth-token"
            @res[:status] = :ok
            return @res
          end

          api_res = @client.all_groups

          unless api_res.code == 200
            @res[:message] = "[Failed] notification is failed. all_groups"
            @res[:status] = :fail
            return @res
          end

          api_res.body.each do |v|
            unless opts[:group][:yammer].index(v[:name].to_sym).nil?
              group_id = v[:id]
              params = { :group_id => group_id }
              params[:replied_to_id] = opts[:thread_id] if opts.key?(:thread_id)

              @client.create_message("Yammerのトークン情報を最新に更新しました", params)
              @res[:message] = "[Success] notification is API get-oauth-token"
              @res[:status] = :ok
              return @res
            end
          end

          @res[:message] = "[Failed] find group bad not found"
          @res[:status] = :fail
          @res
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
