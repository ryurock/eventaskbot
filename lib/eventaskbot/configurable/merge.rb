#
# 異なる設定方法の設定をマージするモジュール
#
module Eventaskbot
  module Configurable
    module Merge
      class << self
        #
        # コマンドラインオプションをマージする
        #
        def command_merge(opts)
          #pp opts

          Eventaskbot.configure do |c|
            c.response = {:format => opts[:format]}
          end
        end
      end
    end
  end
end
