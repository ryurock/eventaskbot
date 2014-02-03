require "uri"
require "yammer"
require "mechanize"
require 'redis'
require 'hiredis'
require 'terminal-table'

require 'eventaskbot/storage'
require 'eventaskbot/services/yammer'

#
# Service Layer Yammer Group Import Module
#
module Eventaskbot
  module Services
    module Yammer
      class UserImport

        attr_accessor :client, :res, :code, :api_url

        def initialize
          @res     = {:status => :fail, :message => "", :response => []}
          @api_url = "/api/v1/users/in_group/"
        end

        #
        # 実行メソッド
        # @opts[Hash] パラメーターオプション
        # @return[Hash] レスポンス
        #
        def execute(opts)
          #配列の値をバリデート
          [:group, :command].each{ |v| return @res if validate opts, v }

          key     = "access_token_yammer"

          conf    = Eventaskbot.options
          storage = Eventaskbot::Storage.register_driver(conf[:storage])

          @client = ::Yammer::Client.new(:access_token => storage.get(key)) if @client.nil?

          command = nil

          [:in_group, :user].each do |v|
            next unless opts[:command] == v
            command = v
          end

          if command.nil?
            @res[:message] = "[Failed] API options command is unknown. #{opts[:command]}"
            @res[:status] = :fail
            return @res
          end

          #グループからユーザー情報をインポートする
          in_group_execute(opts) if command == :in_group

          @res
        end

        #
        # グループ情報からのユーザー情報のインポートを行う
        # @param opts[Hash] 設定値
        # @return void
        #
        def in_group_execute(opts)
          #グループ情報を取得する
          opts[:group].each do |v|
            params  = {:page => 1}
            api_url = "#{@api_url}#{v}"
            api_res = @client.get(api_url, params)

            unless api_res.code == 200
              @res[:message] = "[Failed] API in_group is failed. response code id #{api_res.code}"
              @res[:status] = :fail
              return @res
            end

            while api_res.body[:more_available] == true do
              params[:page] = params[:page] + 1
              api_url = "#{@api_url}#{v}"
              api_res = @client.get(api_url, params)

              api_res.body[:users].each do |user|
                next if user[:type] != "user" || user.key?(:id) == false || user.key?(:name) == false || user.key?(:full_name) == false
                @res[:response].push({
                  :id        => user[:id],
                  :name      => user[:name],
                  :mension   => "@#{user[:name]}",
                  :full_name => user[:full_name]
                })
              end
            end

            table = Terminal::Table.new :headings => ['id', 'name', "mension", "full_name"], :rows => @res[:response]
            message = "[Success] Yammer API in_group get\n"
            message << "#{table}\n"

            @res[:status] = :ok
            @res[:message] = message
          end
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
