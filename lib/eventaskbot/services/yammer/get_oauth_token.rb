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
        YAM_URL = "https://www.yammer.com"

        attr_accessor :client, :res
        def initialize
          @res = {:status => :fail, :message => ""}
        end

        def execute(opts)
          #配列の値をバリデート
          [:user, :pass, :client_id, :client_secret].each{ |v| return @res if validate opts, v }

          agent = Mechanize.new
          page = agent.get("#{YAM_URL}/login")

          page = page.form_with(:id => 'login-form') do |form|
            form.login    = opts[:user]
            form.password = opts[:pass]
          end.submit

          #強引だが例外で出たURLをパースしてごまかす
          begin
            page = agent.get("#{YAM_URL}/dialog/oauth?client_id=#{opts[:client_id]}&response_type=code")
          rescue Mechanize::ResponseCodeError => ex
            url  = URI.extract(ex.message)[1]
            code = CGI.parse(URI.parse(url).query)["code"][0]
          end

          if code.nil?
            @res[:message] = "[Failed] dialog/oauth try get code. but failed"
            return @res
          end

          page = agent.get("#{YAM_URL}/oauth2/access_token.json?client_id=#{opts[:client_id]}&client_secret=#{opts[:client_secret]}&code=#{code}")
          json = MultiJson.load(page.body, :symbolize_keys => true)

          @res = {
            :status  => :ok,
            :message => "[Success] oauth token is #{json[:access_token][:token]}",
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
