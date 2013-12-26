require 'eventaskbot'
require 'eventaskbot/command'
require 'eventaskbot/handler/configurable_filter'
require 'eventaskbot/configurable/merge'

#
# 通知側とタスク側に設定を渡すモジュール
#
module Eventaskbot
  module Handler

    include ConfigurableFilter
    include Configurable::Merge

    #
    # 要求の実行
    #
    def run(opts = {:command => nil})
      #設定ファイルを設定にマージする
      Configurable::Merge.config_file(Eventaskbot.options)

      Configurable::Merge.command(opts[:command])

      #設定をフィルタリング
      opts = ConfigurableFilter.filter(Eventaskbot.options)
      api_handler(opts)
    end

    #
    # とりあえず実装で場所移す
    #
    def api_handler(opts)
      path = File.expand_path(__FILE__ + "../../api/#{opts[:api][:type].to_s}/#{opts[:api][:name].gsub(/-/, "_")}")
      require path

      klass_name = opts[:api][:name].split("-").inject([]) do |a,v|
        a.push(v.capitalize)
      end

      klass = "Eventaskbot::Api::#{opts[:api][:type].to_s.capitalize}::#{klass_name.join("")}.new"
      eval klass
    end
  end
end
