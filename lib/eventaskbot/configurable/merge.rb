#
# 異なる設定方法の設定をマージするモジュール
#
module Eventaskbot
  module Configurable
    module Merge
      class << self
        #
        # コマンドラインオプションをマージする
        # @params [Hash] OptionParserで受け取ったオプションのハッシュ値
        #
        def command_merge(opts)
          Eventaskbot.configure do |c|
            c.response          = {}
            c.response[:format] = opts[:format] if opts.key? :format
            c.api               = {}
            c.api[:name]        = opts[:api][:name] if opts.key?(:api) && opts[:api].key?(:name)
            c.api[:params]      = opts[:api][:params] if opts.key?(:api) && opts[:api].key?(:params)
          end

          self
        end

        #
        # EventaskbotFileをマージする
        #
        def eventaskbotfile_merge(path)
          raise "#{path} File is not Found" unless FileTest.exist? path
          load path

          self
        end
      end
    end
  end
end
