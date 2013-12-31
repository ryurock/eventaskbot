require 'capybara'
require 'capybara/dsl'

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
          opts = {} if opts == nil

          @res = {:status => :fail, :message => ""}

          service = {}

          service = opts[:service] if opts.key?(:service)
          service = service.merge(params[:service]) if params.key?(:service)

          if service.size == 0
            @res[:message] = "[Failed] parametor or EventaskbotFile Setting service parametor not found"
            return @res
          end

          service.each do |service, v|
            @res = filter(v)

            return @res if @res[:status] == :fail

            Capybara.run_server = false
            Capybara.default_driver = :webkit

          end

          @res
        end

        private
          def filter(val)
            res = {:status => :fail, :message => ""}

            unless val.is_a?(Hash)
              res[:message] = "[Failed] parametor wrong. using to Hash"
              return res
            end

            unless val.key? :user
              res[:message] = "[Failed] parametor or EventaskbotFile Setting :service => :user is not found"
              return res
            end

            unless val.key? :pass
              res[:message] = "[Failed] parametor or EventaskbotFile Setting :service => :pass is not found"
              return res
            end

            res = {:status => :ok}
          end
      end
    end
  end
end
