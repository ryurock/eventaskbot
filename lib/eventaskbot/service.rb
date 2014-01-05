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

    def config_merge
      opts = Eventaskbot.options
      api_name   = opts[:api][:name].gsub(/-/, "_").to_sym
      sub_conf = eval "Eventaskbot::Api::#{opts[:api][:type].to_s.capitalize}.options"
      @params = deep_merge(@params, opts[:service])                if opts.key?(:service)
      @params = deep_merge(@params, sub_conf[api_name][:service])  if sub_conf_options_exist(sub_conf,api_name, :service)
      @params = deep_merge(@params, opts[:api][:params][:service]) if opts[:api][:params].key?(:service)

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
      # 階層の深いマージ
      # @param service[Hash] マージ元
      # @param opts[Hash] マージしたい値
      # @return [Hash] マージした値
      #
      def deep_merge(service, opts)
        if service.size > 0
          service = service.inject({}) do |h,(k,v)|
            h[k] = v
            h[k] = h[k].merge(opts[k]) if opts.key? k
            h
          end
        else
          service = opts
        end

        service
      end

      def sub_conf_options_exist(sub_conf,api_name, key)
        return false if     sub_conf.nil?
        return false unless sub_conf.key?(api_name)
        return false if     sub_conf[api_name].nil?
        return false unless sub_conf[api_name].key?(key)
        return true
      end
  end
end
