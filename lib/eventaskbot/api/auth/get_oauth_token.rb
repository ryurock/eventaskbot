require 'eventaskbot/storage'

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

            key   = "access_token_#{service_name}"
            value = @res[:response]
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
