require "uri"
require "yammer"
require "mechanize"
require 'redis'
require 'hiredis'
require 'terminal-table'
require 'parallel'
require 'multi_json'

require 'eventaskbot/storage'
require 'eventaskbot/services/yammer'

#
# Service Layer Yammer Group Import Module
#
module Eventaskbot
  module Services
    module Yammer
      class UserImport

        attr_accessor :client, :res, :code, :api_url, :prefix_storage_key, :storage

        def initialize
          @res     = {:status => :fail, :message => "", :response => []}
          @api_url = "/api/v1/users/in_group/"
          @conf    = Eventaskbot.options
          @storage = Eventaskbot::Storage.register_driver(@conf[:storage])
          @prefix_storage_key = "yam_user_"
        end

        #
        # 実行メソッド
        # @opts[Hash] パラメーターオプション
        # @return[Hash] レスポンス
        #
        def execute(opts)
          #配列の値をバリデート
          [:group, :import_type].each{ |v| return @res if validate opts, v }

          key     = "access_token_yammer"
          @client = ::Yammer::Client.new(:access_token => @storage.get(key)) if @client.nil?

          import_type = nil

          [:in_group, :user].each do |v|
            next unless opts[:import_type] == v
            import_type = v
          end

          if import_type.nil?
            @res[:message] = "[Failed] API options command is unknown. #{opts[:import_type]}"
            @res[:status] = :fail
            return @res
          end

          #グループからユーザー情報をインポートする
          in_group_execute(opts) if import_type == :in_group

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
            api_url      = "#{@api_url}#{v}"
            group_users  = []
            page_param   = 1
            thread       = []

            que = ::Queue.new
            #とりあえず10ページ
            [1,2,3,4,5,6,7,8,9,10].each { |a| que.push(a) }

            t1, t2, t3 = in_group_thread(group_users, api_url, que, 1),
                         in_group_thread(group_users, api_url, que, 2),
                         in_group_thread(group_users, api_url, que, 3)
            t1.join
            t2.join
            t3.join

            if @res[:status] == :fail
              @res[:message] = "[Failed] API in_group is failed. response code is not 200"
              return @res
            end

            table_rows = []
            users      = []

            group_users.each do |group_user|
              res = find_user_info_more(group_user)
              users.push(res)

              table_rows << [res[:id], res[:email], res[:full_name] ]
            end

            table = Terminal::Table.new :headings => ['id', "email", "full_name"], :rows => table_rows
            message = "[Success] Yammer API in_group and User result.\n"
            message << "#{table}\n"
            @res[:message] = message
            @res[:status] = :ok
            @res
          end
        end

        #
        # in_group API用のスレッド
        #
        # @param[String] API URL
        # @param[Queue] Queue
        # @return Thread
        #
        def in_group_thread(inject_hash, api_url, que, num = 1)
          Thread.new do
            until que.empty?
              page_val = que.pop
              api_res = @client.get(api_url, { :page => page_val } )
              #apiレスポンスに異常があった場合はキューを空にして終了
              unless api_res.code == 200
                @res[:status] = :fail
                que.clear
                break
              end

              inject_hash.concat(api_res.body[:users])
              #ページングのレスポンスがこれ以上ない場合はqueをクリアする
              que.clear if api_res.body[:more_available] == false
              #pp "thread1 Start #{num}"
              sleep(3)
            end
          end
        end

        #
        # ユーザー情報の詳細を検索する
        # @param user[Hash] グループ情報のユーザー情報
        # @retry_cnt[Intgeer] リトライ回数
        # @return [Hash] 詳細な情報を含んだユーザー情報
        #
        def find_user_info_more(user, retry_cnt = 1)
          raise "retry max over" if retry_cnt >= 5
          user_info = @storage.get("#{@prefix_storage_key}#{user[:id]}")

          return MultiJson.load(user_info, :symbolize_keys => true) unless user_info.nil?

          api_res = @client.get_user(user[:id])

          unless api_res.code == 200
            # 5病待ってリトライ
            sleep(5)
            #pp "retry start!!!"
            return find_user_info_more(user, (retry_cnt + 1))
          end


          res = {
            :id        => api_res.body[:id],
            :name      => api_res.body[:name],
            :full_name => api_res.body[:full_name],
            :mension   => "@#{api_res.body[:name]}",
            :email     => api_res.body[:contact][:email_addresses][0][:address]
          }

          user_info = MultiJson.dump(res)
          #ストレージに保存する
          @storage.set("#{@prefix_storage_key}#{user[:id]}", user_info)

          MultiJson.load(user_info, :symbolize_keys => true)
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
