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
      #コマンドラインオプションの設定を設定にマージする
      comm =  Configurable::Merge.command(opts[:command])
      #API名が存在しない場合はエラーになる
      raise "API setting not found." if     comm[:api].nil?
      raise "API name unkwon."       unless comm[:api].key?(:name)

      #initだけは設定ファイルを作成するのでマージは行わない
      Configurable::Merge.config_file(Eventaskbot.options ) unless comm[:api][:name].to_s == "init"

      #コマンドラインオプションの設定を設定にマージする
      Configurable::Merge.command(opts[:command])

      #設定をフィルタリング
      conf = Configurable::Filter.filter(Eventaskbot.options)
      conf[:api][:klass].execute
    end
  end
end
