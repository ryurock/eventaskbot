require 'eventaskbot/storage'
require 'terminal-table'
require "eventaskbot/notifications/yammer/create_thread"

#
# Auth GetOauthToken  API
#
module Eventaskbot
  module Api
    module Group
      class UserImport
        attr_accessor :res

        def execute(params)
          if opts.nil? || opts.key?(:service) == false
            @res[:message] << "[Failed] Setting service parametor not found"
            return @res
          end

          #opts[:service].each do |service_name, v|
          #  @res = v[:klass].execute(v)
          #  return @res unless @res[:status] == :ok

          #  #閲覧だけの場合はストレージに保存しない
          #  return @res if params.key?(:watch_token)

          #  storage = Eventaskbot::Storage.register_driver(opts[:storage])

          #  #ストレージにデータを保存
          #  key   = "access_token_#{service_name}"
          #  value = @res[:response]

          #  #tokenの差分を確認したい時
          #  if params.key?(:diff_token)
          #    diff_execute(key, value)
          #  end

          #  storage.set(key, value)

          #  next if opts.key?(:notify) == false || opts[:notify].key?(:klass) == false || opts[:notify][:klass].key?(service_name) == false


          #  notify_opts = v
          #  notify_opts[:access_token] = value
          #  notify_opts = notify_opts.merge(opts[:notify])
          #  notify_execute(notify_opts)
          #end

          @res
        end

        #
        # スレッドの指定がある場合はそのスレッドに対してnotifyない場合は指定されたグループにスレッドを作成する
        # @param opts[Hash] notifyの設定値
        # @return nil
        #
        def notify_execute(opts)
          #スレッド指定の場合はスレッドがなければ作成してある場合は参照する
          if opts.key?(:group) && opts[:group].key?(:yammer)
            opts[:group][:yammer].each do |v|
              notify_key_name   = "notify_thread_#{v}"
              notify_thread_id  = Eventaskbot::Storage.get(notify_key_name)

              #スレッドを作成する
              if notify_thread_id.nil?
                thread_res        = Eventaskbot::Notifications::Yammer::CreateThread.new.execute(opts)
                notify_thread_id  = thread_res[:response].body[:messages][0][:id]
                Eventaskbot::Storage.set(notify_key_name, notify_thread_id)
              end

              opts[:thread_id] = notify_thread_id
            end
          end

          #notification
          notify_res = opts[:klass].each do |service_name, v|
            notify_res = v.execute(opts)
            @res[:message] << notify_res[:message]
          end
        end

        #
        #
        #
        #
        def diff_execute(key, value)
           old_token = Eventaskbot::Storage.get(key)

           rows = []
           rows << ["old_access_token", old_token]
           rows << ["new_access_token", value]
           table = Terminal::Table.new :rows => rows

           message = "[Success] access_token diff is\n"
           message << "#{table}\n"
           @res[:message] = message
           @res[:response] = {:old_access_token => old_token, :new_access_token => value}
           return @res
        end
      end
    end
  end
end
