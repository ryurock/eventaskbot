require "uri"
require "yammer"
require "mechanize"
require 'redis'
require 'hiredis'
require 'terminal-table'
require 'eventaskbot/services/yammer'

#
# Plugins Yammer Module
#
module Eventaskbot
  module Services
    module Yammer
      class GetOauthToken
        attr_accessor :client, :res, :code

        def initialize
          @res    = {:status => :fail, :message => ""}
          @client = Mechanize.new
        end

        #
        # 実行メソッド
        # @opts[Hash] パラメーターオプション
        # @return[Hash] レスポンス
        #
        def execute(opts)
          #配列の値をバリデート
          [:user, :pass, :client_id, :client_secret].each{ |v| return @res if validate opts, v }

          page = @client.get("#{Yammer.host}/login")

          page = page.form_with(:id => 'login-form') do |form|
            form.login    = opts[:user]
            form.password = opts[:pass]
          end.submit

          #強引だが例外で出たURLをパースしてごまかす(なのでredirect_urlが正常に返ってくるapiコードは取得できない)
          begin
            page = @client.get("#{Yammer.host}/dialog/oauth?client_id=#{opts[:client_id]}&response_type=code")
          rescue Mechanize::ResponseCodeError => ex
            url  = URI.extract(ex.message)[1]
            @code = CGI.parse(URI.parse(url).query)["code"][0]
          end

          if @code.nil?
            @res[:message] = "[Failed] dialog/oauth try get code. but failed"
            @res[:status]  = :fail
            return @res
          end

          page = @client.get("#{Yammer.host}/oauth2/access_token.json?client_id=#{opts[:client_id]}&client_secret=#{opts[:client_secret]}&code=#{code}")
          json = MultiJson.load(page.body, :symbolize_keys => true)

          rows = []
          rows << [json[:access_token][:token]]
          table = Terminal::Table.new :headings => ['access_token'], :rows => rows

          message = "[Success] oauth token get\n"
          message << "#{table}\n"

          @res = {
            :status  => :ok,
            :message => message,
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
