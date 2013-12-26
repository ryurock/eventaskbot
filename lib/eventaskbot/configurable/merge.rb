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
        #
        def config_file(path)
          raise "#{path} File is not Found" unless FileTest.exist? path
          load path

          self
        end
      end
    end
  end
end
