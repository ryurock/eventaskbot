require 'eventaskbot/storage'
require 'terminal-table'

#
# Auth GetOauthToken  API
#
module Eventaskbot
  module Api
    module Auth
      class GetOauthToken
        attr_accessor :res
        def execute(params)
          opts = Auth.option(:get_oauth_token)
          @res = {:status => :fail, :message => ""}

          if opts.nil? || opts.key?(:service) == false
            @res[:message] = "[Failed] Setting service parametor not found"
            return @res
          end

          opts[:service].each do |service_name, v|
            @res = v[:klass].execute(v)
            return @res unless @res[:status] == :ok

            #閲覧だけの場合はストレージに保存しない
            return @res if params.key?(:watch_token)

            storage = Eventaskbot::Storage.register_driver(opts[:storage])

            #ストレージにデータを保存
            key   = "access_token_#{service_name}"
            value = @res[:response]

            #tokenの差分を確認したい時
            if params.key?(:diff_token)
              old_token = storage.get(key)

              rows = []
              rows << ["old_access_token", old_token]
              rows << ["new_access_token", value]
              table = Terminal::Table.new :rows => rows

              message = "[Success] access_token diff is\n"
              message << "#{table}"
              @res[:message] = message
              @res[:response] = {:old_access_token => old_token, :new_access_token => value}
            end

            storage.set(key, value)

          end

          #return @res if opts.key?(:notify) == false || opts[:notify].key?(:klass) == false

          #opts[:notify].each do |k,v|
          #end

          @res
        end
      end
    end
  end
end
