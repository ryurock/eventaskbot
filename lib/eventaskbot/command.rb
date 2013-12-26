require 'optparse'

#
# コマンドラインを扱うクラス
#
module Eventaskbot
  class Command
    attr_accessor :opts, :argv

    #
    # イニシャライズ
    #
    # @param argv[Array] コマンドライン引数
    #
    def initialize(argv = [])
      if argv.size == 0
        @argv = ARGV
      else
        @argv = argv
      end
    end

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
          @opts[:format] = v
        end

        opt.on('-c', '--config=CONF_FILE', 'eventaskbot configure File') do |v|
          @opts[:conf_file] = v

          #設定ファイルのpathは先に設定に追加しておきたいので追加
          Eventaskbot.configure do |c|
            c.config_file = {} if c.config_file.nil?
            c.config_file[:path] = v
          end

        end

        #formatの指定がない場合のデフォルトは.jsonになる
        @opts[:format] = 'json' unless @opts.key?(:format)

        argv = opt.parse(@argv)

        raise "Command Line Error. Please specify argment1." if argv.size <= 0
        @opts[:api] = {}
        @opts[:api][:name] = argv[0]

        @opts[:api][:params] = {}
        @opts[:api][:params] = eval argv[1] if argv.size > 1

      end.getopts
    end
  end
end
