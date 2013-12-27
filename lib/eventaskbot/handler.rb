require 'eventaskbot'
require 'eventaskbot/command'
require 'eventaskbot/configurable/filter'
require 'eventaskbot/configurable/merge'

#
# 通知側とタスク側に設定を渡すモジュール
#
module Eventaskbot
  module Handler

    include Configurable::Filter
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
      opts = Configurable::Filter.filter(Eventaskbot.options)
    end
  end
end
