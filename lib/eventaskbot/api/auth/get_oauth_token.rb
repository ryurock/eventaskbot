#
# Auth GetOauthToken  API
#
module Eventaskbot
  module Api
    module Auth
      class GetOauthToken
        attr_accessor :res
        def execute(params)
          opts = Eventaskbot.options

          auth_opts = Auth.option(:get_oauth_token)
          auth_opts = {} if auth_opts == nil

          service = {}
          service = opts[:service]            if opts.key?(:service) && opts[:service].nil? == false
          service = merge(service, auth_opts) if auth_opts.key?(:service)
          service = merge(service, params)    if params.key?(:service)

          @res = {:status => :fail, :message => ""}

          if service.size == 0
            @res[:message] = "[Failed] parametor or EventaskbotFile Setting service parametor not found"
            return @res
          end

          service.each do |service, v|
            unless v.is_a?(Hash)
              @res[:message] = "[Failed] parametor wrong. using to Hash"
              return @res
            end

            unless v.key?(:klass)
              @res[:message] = "[Failed] service Class not found"
              return @res
            end
            @res = v[:klass].get_oauth_token(v)
          end

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
