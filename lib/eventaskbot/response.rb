#
# Evetaskboy Response module
#
module Eventaskbot
  class Response
    attr_accessor :res

    def initialize(api)
      @res = api.res
    end

    def status
      res[:status]
    end

    def status_ok?
      return true if res[:status] == :ok
      false
    end

    def message
      return res[:message]
    end
  end
end
