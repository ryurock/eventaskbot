require 'eventaskbot'
require 'eventaskbot/configurable'
require 'eventaskbot/api/etc'
require 'eventaskbot/api/collector'

#
# 異なる設定方法の設定をマージするモジュール
#
module Eventaskbot
  module Configurable
    module Merge
      class << self
        #
        # コマンドラインオプションを設定にマージする
        # @params [Eventaskbot::Command] コマンドラインオプションクラス
        # @return Eventaskbot
        #
        def command(obj)
          return if obj.nil?

          Eventaskbot.configure do |c|
            c.response          = {}                   if c.response.nil?
            c.response[:format] = obj.opts[:format]    if obj.opts.key? :format

            c.api               = {}                         if obj.opts.key?(:api) && c.api.nil?
            c.api[:name]        = obj.opts[:api][:name]      if obj.opts.key?(:api) && obj.opts[:api].key?(:name)
            c.api[:params]      = obj.opts[:api][:params]    if obj.opts.key?(:api) && obj.opts[:api].key?(:params)
          end
        end

        #
        # EventaskbotFileをマージする
        # @param opts[Hash] 設定値のHash
        # @return [Hash] マージ後の設定値
        #
        def config_file(opts)
          cur_path = "#{Dir.pwd}/EventaskbotFile"
          unless opts.key?(:config_file)
            load cur_path
            return Eventaskbot.options
          end

          if opts[:config_file].nil?
            load cur_path
            return Eventaskbot.options
          end

          unless opts[:config_file].key?(:path)
            load cur_path
            return Eventaskbot.options
          end

          load opts[:config_file][:path]

          Eventaskbot.options
        end
      end
    end
  end
end
