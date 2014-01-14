require "uri"
require "yammer"
require "mechanize"

#
# Plugins Yammer Module
#
module Eventaskbot
  module Services
    module Yammer
      class GetOauthToken
        include Capybara::DSL

        attr_accessor :client, :res
        def initialize
          @res = {:status => :fail, :message => ""}
        end

        def execute(opts)
          #配列の値をバリデート
          [:user, :pass, :client_id, :client_secret].each{ |v| return @res if validate opts, v }
          agent = Mechanize.new
          agent.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1539.0 Safari/537.36"
          page = agent.get('https://www.yammer.com/login')

          page = page.form_with(:id => 'login-form') do |form|
            form.login    = opts[:user]
            form.password = opts[:pass]
          end.submit

          #強引だが例外で出たURLをパースしてごまかす
          begin
            page = agent.get("https://www.yammer.com/dialog/oauth?client_id=#{opts[:client_id]}&response_type=code")
          rescue Mechanize::ResponseCodeError => ex
            pp URI.extract(ex.message)[1]
          end
          @res[:status] = :ok
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
