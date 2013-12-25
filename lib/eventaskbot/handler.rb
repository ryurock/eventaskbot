require 'eventaskbot'
require 'eventaskbot/handler/configurable_filter'
require 'eventaskbot/handler/configurable_filter'

#
# 通知側とタスク側に設定を渡すモジュール
#
module Eventaskbot
  module Handler

    include ConfigurableFilter

    #
    # 要求の実行
    #
    def run
      #設定をフィルタリング
      opts = ConfigurableFilter.filter(Eventaskbot.options)
      api_handler(opts)
    end

    #
    # とりあえず実装で場所移す
    #
    def api_handler(opts)
      path = File.expand_path(__FILE__ + "../../api/#{opts[:api][:type].to_s}/#{opts[:api][:name]}")
      require path
      klass = "Eventaskbot::Api::#{opts[:api][:type].to_s.capitalize}::#{opts[:api][:name].capitalize}.new"
      eval klass
    end
  end
end
