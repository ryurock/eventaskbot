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
      #コマンドラインオプションの設定を設定にマージする
      Configurable::Merge.command(opts[:command])

      #設定をフィルタリング
      opts = ConfigurableFilter.filter(Eventaskbot.options)
    end
  end
end
