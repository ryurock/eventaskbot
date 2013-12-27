#
# 設定をフィルタリングするモジュール
#
module Eventaskbot
  module Configurable
    module Filter
      module Api

        #
        # フィルター
        # @param options[Hash] 設定された値
        # @return [Hash] filterして追加、削除した値の設定値
        #
        def self.filter(opts)
          raise "options :api is NilClass."           if     opts.nil?
          raise "options :api[:name] is NilClass."    if     opts[:name].nil?

          opts[:name] = opts[:name].to_s
          raise "options api name #{opts[:name]} not found."  unless api_exist?(opts[:name])

          opts[:type]  = :collector unless collector_api_list.index(opts[:name]).nil?
          opts[:type]  = :file      unless file_api_list.index(opts[:name]).nil?
          opts[:type]  = :auth      unless auth_api_list.index(opts[:name]).nil?
          opts[:klass] = api_load(opts[:name], opts[:type])

          opts
        end

        #
        # APIクラスを動的にロード
        # @param name[String] API名
        # @param type[String] API種別
        # @return [Object] 動的にロードされたAPIインスタンス
        #
        def self.api_load(name, type)
          path = File.expand_path(__FILE__ + "../../../../api/#{type.to_s}/#{name.gsub(/-/, "_")}")
          require path

          klass_name = name.split("-").inject([]){ |a,v| a.push(v.capitalize) }
          klass = "Eventaskbot::Api::#{type.to_s.capitalize}::#{klass_name.join("")}.new"

          eval klass
        end

        #
        # API名が存在するか検索する
        # @param name[String] API名
        # @return [Boolean] true 存在する | false 存在しない
        #
        def self.api_exist?(name)
          collector_api_list.each{ |v| return true if name == v }
          auth_api_list.each{      |v| return true if name == v }
          file_api_list.each{      |v| return true if name == v }
          false
        end

        #
        # Collector APi一覧を返す
        # @return [Array] Collector API名の一覧
        #
        def self.collector_api_list
          ["terget-set", "has-ticket"]
        end

        #
        # File APi一覧を返す
        # @return [Array] File API名の一覧
        #
        def self.file_api_list
          ["init"]
        end

        #
        # Auth APi一覧を返す
        # @return [Array] Auth API名の一覧
        #
        def self.auth_api_list
          ["get-oauth-token"]
        end
      end
    end
  end
end
