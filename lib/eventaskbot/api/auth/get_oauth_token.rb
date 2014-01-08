#
# Auth GetOauthToken  API
#
module Eventaskbot
  module Api
    module Auth
      class GetOauthToken
        attr_accessor :res
        def execute(params)
          auth_opts = Auth.option(:get_oauth_token)
          @res      = {:status => :fail, :message => ""}

          if auth_opts.nil?
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

        private

          def merge(service, opts)
            if service.size > 0
              service = service.inject({}) do |h,(k,v)|
                h[k] = v
                h[k] = h[k].merge(opts[:service][k]) if opts[:service].key? k
                h
              end
            else
              service = opts[:service]
            end

            service
          end
      end
    end
  end
end
