require "yammer"
require 'capybara'
require 'capybara/dsl'

#
# Plugins Yammer Module
#
module Eventaskbot
  module Plugins
    include Capybara::DSL
    class Yammer
      attr_accessor :client, :res
      def initialize
        @res = {:status => :fail, :message => ""}
      end

      def get_oauth_token(opts)

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
