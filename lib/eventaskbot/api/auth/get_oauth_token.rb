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
            unless v.key?(:klass)
              @res[:message] = "[Failed] service Class not found"
              return @res
            end

            @res = v[:klass].execute(v)
          end

          return @res if opts.key?(:notify) == false || opts[:notify].key?(:klass) == false

          opts[:notify].each do |k,v|
          end

          @res
        end
      end
    end
  end
end
