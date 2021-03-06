require 'eventaskbot'
require 'eventaskbot/configurable'
require 'eventaskbot/api/file'
require 'eventaskbot/api/auth'
require 'eventaskbot/api/user'

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
        # @return [Hash] 追加した設定
        #
        def command(obj)
          return Eventaskbot.options if obj.nil?
          Eventaskbot.configure do |c|
            c.response          = {}                         if c.response.nil?
            c.response[:format] = obj.opts[:format]          if obj.opts.key? :format

            c.api               = {}                         if obj.opts.key?(:api) && c.api.nil?
            c.api[:name]        = obj.opts[:api][:name]      if obj.opts.key?(:api) && obj.opts[:api].key?(:name)
            c.api[:params]      = obj.opts[:api][:params]    if obj.opts.key?(:api) && obj.opts[:api].key?(:params)
          end

          Eventaskbot.options
        end

        #
        # EventaskbotFileをマージする
        # @param opts[Hash] 設定値のHash
        # @return [Hash] マージ後の設定値
        #
        def config_file(opts)
          path = "#{Dir.pwd}/EventaskbotFile"
          path = opts[:config_file][:path] if opts.key?(:config_file) && opts[:config_file].nil? == false && opts[:config_file].key?(:path)

          load path

          Eventaskbot.configure do |c|
            c.config_file          = {}   if c.config_file.nil?
            c.config_file[:path]   = path
          end

          Eventaskbot.options
        end
      end
    end
  end
end
