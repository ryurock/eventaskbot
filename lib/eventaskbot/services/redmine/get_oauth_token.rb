require "yammer"
require 'capybara'
require 'capybara/dsl'

#
# Plugins Yammer Module
#
module Eventaskbot
  module Services
    module Redmine
      class GetOauthToken
        include Capybara::DSL

        attr_accessor :client, :res
        def initialize
          @res = {:status => :fail, :message => ""}
        end

        def execute(opts)

          unless opts.key?(:user)
            @res[:message] = "[Failed] parametor or EventaskbotFile Setting :service => :user is not found"
            return @res
          end

          unless opts.key? :pass
            @res[:message] = "[Failed] parametor or EventaskbotFile Setting :service => :pass is not found"
            return @res
          end

          Capybara.run_server = false
          Capybara.default_driver = :webkit

          @res[:status] = :ok
          @res
        end
      end
    end
  end
end
