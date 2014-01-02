#
# 設定のServiceをフィルタリングするモジュール
#
module Eventaskbot
  module Configurable
    module Filter
      module Service

        #
        # フィルター
        # @param options[Hash] 設定された値
        # @return [Hash] filterして追加、削除した値の設定値
        #
        def self.filter(opts)
          return opts if opts.nil?
          raise "options service is not Hash" unless opts.instance_of?(Hash)

          plugins_path = File.expand_path('../../../../../plugins', __FILE__)
          $LOAD_PATH.unshift(plugins_path) unless $LOAD_PATH.include?(plugins_path)

          opts = opts.inject({}) do |h, (k,v)|

            h[k] = v
            path = File.expand_path(__FILE__ + "../../../../../../plugins/eventaskbot-#{k.to_s}-plugins/#{k.to_s}")
            raise "file not found. plugins #{path}" unless File.exist? "#{path}.rb"
            require path

            klass = "Eventaskbot::Plugins::#{k.to_s.capitalize}.new"
            h[k][:klass] = eval klass

            h
          end
        end
      end
    end
  end
end
