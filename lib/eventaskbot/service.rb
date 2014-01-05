#
# サービスに関するベースクラス
#
module Eventaskbot
  class Service
    attr_reader :params, :services

    def initialize
      @params   = {}
      @services = []
    end

    def import
      opts = Eventaskbot.options
      api_name   = opts[:api][:name].gsub(/-/, "_").to_sym
      sub_conf = eval "Eventaskbot::Api::#{opts[:api][:type].to_s.capitalize}.options"

      @params = collect(@params, opts[:service])                if opts.key?(:service)
      @params = collect(@params, sub_conf[api_name][:service])  if sub_conf_options_exist(sub_conf,api_name, :service)
      @params = collect(@params, opts[:api][:params][:service]) if opts[:api][:params].key?(:service)

      #sub設定でサービスの指定がある場合は削除する
      if sub_conf_options_exist(sub_conf,api_name, :services)
        @params = @params.inject({}) do |h,(k,v)|
          h[k] = v unless sub_conf[api_name][:services].index(k).nil?
          h
        end
      end

      #apiのパラメーターでサービスの指定がある場合は削除する
      if opts[:api][:params].key?(:services)
        @params = @params.inject({}) do |h,(k,v)|
          h[k] = v unless opts[:api][:params][:services].index(k).nil?
          h
        end
      end

      @services = @params.keys

      return self unless has_service?

      @services.each do |v|
        path = File.expand_path("../services/#{v}/#{opts[:api][:name].gsub(/-/,"_")}",__FILE__)
        require path

        klass_name = opts[:api][:name].split("-").inject([]){ |a,v| a.push(v.capitalize) }
        klass = "Eventaskbot::Services::#{v.capitalize}::#{klass_name.join("")}.new"
        @params[:klass] = eval klass
      end

      self
    end

    #
    # serviceが存在するか？
    # @return [Boolean] true 存在する | false 存在しない
    #
    def has_service?
      return false if @services.empty?
      true
    end

    private

      #
      # 値を取得してマージする
      # @param service[Hash] マージ元
      # @param opts[Hash] マージしたい値
      # @return [Hash] マージした値
      #
      def collect(service, opts)
        if service.empty?
          service = opts
          return service
        end

        service.inject({}) do |h,(k,v)|
          h[k] = v
          h[k] = h[k].merge(opts[k]) if opts.key? k
          h
        end
      end
      
      #
      # sub設定に設定が存在するか？
      # @param sub_conf[Hash | nil] sub_confの全設定
      # @param api_name[Symbol] 設定値のAPi名
      # @param key[Symbol] 設定の中の値
      # @return [Boolean] true 存在する | false 存在しない
      #
      def sub_conf_options_exist(sub_conf,api_name, key)
        return false if     sub_conf.nil? || sub_conf.key?(api_name) == false
        return false if     sub_conf[api_name].nil? || sub_conf[api_name].key?(key) == false
        return false unless sub_conf[api_name].key?(key)
        return true
      end
  end
end
