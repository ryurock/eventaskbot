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
          pp opts
          @res = {:status => :fail, :message => ""}

          if opts.nil?
            @res[:message] = "[Failed] Setting service parametor not found"
            return @res
          end

          opts.each do |service_name, v|
            unless v.key?(:klass)
              @res[:message] = "[Failed] service Class not found"
              return @res
            end

            @res = v[:klass].execute(v)
          end

          @res
        end
      end
    end
  end
end
