require 'optparse'

#
# コマンドラインを扱うクラス
#
module Eventaskbot
  class Command

    #
    # コマンドラインオプションを取得する
    #
    def get
      @opts = {}

      OptionParser.new do |opt|
        opt.version = Eventaskbot::VERSION
        opt.banner= 'eventaskbot argument [options]'
        opt.on('-i', '--init', 'task-hunter initialize') do |v|
          puts v
        end

        opt.on('-f', '--format=FORMAT', 'eventaskbot response format') do |v|
          formats = ["json", "text", "hash"]
          formats.each{ |format| @opts[:format] = v if v == format }
          raise "Invalid Format #{v}" if @opts[:format].nil?
        end

        @opts[:format] = 'json' unless @opts.key?(:format)

        opt.permute!(ARGV)

        #formatの指定がない場合のデフォルトは.jsonになる
        raise "Command Line Error. Please specify argment1." if ARGV.length == 0
        @opts[:api] = {}
        @opts[:api][:name] = ARGV.shift

        @opts[:api][:params] = {}
        @opts[:api][:params] = eval ARGV.shift if ARGV.length >= 1

      end.getopts
    end

    #
    # コマンドラインオプションを設定にマージする
    #
    def merge(value)
    end
  end
end
