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

          if opts.nil?
            @res[:message] = "[Failed] Setting service parametor not found"
            return @res
          end
          
#            unless v.key?(:klass)
#              @res[:message] = "[Failed] service Class not found"
#              return @res
#            end
#            @res = v[:klass].get_oauth_token(v)

          @res
        end
      end
    end
  end
end
