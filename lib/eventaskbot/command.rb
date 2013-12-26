require 'optparse'

#
# コマンドラインを扱うクラス
#
module Eventaskbot
  class Command
    attr_accessor :opts

    #
    # コマンドラインオプションを取得する
    #
    def get(name)
      raise "command get Error. not found  key is #{name}" unless @opts.key? name
      @opts[name]
    end

    #
    # コマンドラインオプションを設定にマージする
    #
    def parse(argv = [])
      argv = ARGV if argv.size == 0

      @opts = {}

      OptionParser.new do |opt|
        opt.version = Eventaskbot::VERSION
        opt.banner= 'eventaskbot argument [options]'

        opt.on('-f', '--format=FORMAT', 'eventaskbot response format') do |v|
          @opts[:format] = v
        end

        opt.on('-c', '--config=CONF_FILE', 'eventaskbot configure File') do |v|
          @opts[:conf_file] = v
        end

        #formatの指定がない場合のデフォルトは.jsonになる
        @opts[:format] = 'json' unless @opts.key?(:format)

        argv = opt.parse(argv)

        raise "Command Line Error. Please specify argment1." if argv.size <= 0
        @opts[:api] = {}
        @opts[:api][:name] = argv[0]

        @opts[:api][:params] = {}
        @opts[:api][:params] = eval argv[1] if argv.size > 1

      end.getopts
    end
  end
end
