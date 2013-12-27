require 'eventaskbot/api/file'

#
# File/Init API
#
module Eventaskbot
  module Api
    module File
      class Init

        include File

        def execute
          parent_opts = File.option :init
          parent_opts
        end
      end
    end
  end
end
