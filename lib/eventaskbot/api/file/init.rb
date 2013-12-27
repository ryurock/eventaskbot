require 'eventaskbot/api/file'

#
# File/Init API
#
module Eventaskbot
  module Api
    module File
      class Init
        attr_accessor :res

        def execute(params)
          opts = File.option(:init)
          opts = {} if opts == nil

          src  = ::File.expand_path('../../../../EventaskbotFile', ::File.dirname(__FILE__))
          dest = "#{Dir.pwd}/EventaskbotFile"
          dest = params[:dest] if params.key?(:dest)

          if ::File.exist? dest
            @res = {:status => :fail, :message => "[Failed] Can't Created EventaskbotFile. Already Exist"}
            if opts.key?(:force) && opts[:force] == true || params.key?(:force) && params[:force] == true
              FileUtils.cp src, dest
              @res = { :status => :ok, :message => "[Created] Setting File dest : #{dest}" }
            end

            return @res
          end

          @res = { :status => :ok, :message => "[Created] Setting File dest : #{dest}" }
        end
      end
    end
  end
end
