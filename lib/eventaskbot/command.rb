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
    def parse
      @opts = {}

      OptionParser.new do |opt|
        opt.version = Eventaskbot::VERSION
        opt.banner= 'eventaskbot argument [options]'

        opt.on('-f', '--format=FORMAT', 'eventaskbot response format') do |v|
          res = nil

          ["json", "text", "hash"].each do |format|
            if v == format
              res = format
              break
            end
          end

          raise "Invalid Format #{v}" if res.nil?
          @opts[:format] = v
        end

        #formatの指定がない場合のデフォルトは.jsonになる
        @opts[:format] = 'json' unless @opts.key?(:format)

        opt.permute!(ARGV)

        raise "Command Line Error. Please specify argment1." if ARGV.length == 0
        @opts[:api] = {}
        @opts[:api][:name] = ARGV.shift

        @opts[:api][:params] = {}
        @opts[:api][:params] = eval ARGV.shift if ARGV.length >= 1

      end.getopts
    end
  end
end
