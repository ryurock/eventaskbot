# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/api/user/user_import'
require 'eventaskbot/notifications/yammer/get_oauth_token'

describe Eventaskbot::Api::User::UserImport, "Eventaskbot User/user-import API Class" do
  before(:each) do
    Eventaskbot::Api::User.reset
    Eventaskbot.reset
   # #yammerに飛ばさないようのモック
   # module Mock
   #   class Eventaskbot::Notifications::Yammer::CreateThread
   #     def self.mock!(opts)
   #       include MockExt
   #       alias_method :old_execute, :execute
   #       alias_method :execute, :mock_execute
   #     end

   #     def self.unmock!(opts)
   #       return unless method_defined? :mock_execute
   #       alias_method :execute, :old_execute # 別名で定義したold_sayにsayという別名をつける
   #     end
   #     module MockExt
   #       def mock_execute(opts)
   #         { :response => MockMethod }
   #       end
   #     end

   #     module MockMethod
   #       def self.body
   #         { :messages => [{:id => 1000000}]}
   #       end
   #     end
   #   end
   # end
   # Eventaskbot::Notifications::Yammer::CreateThread.mock!({})


   # def auth_configure_mock_set(mock, notify_opts)
   #   Eventaskbot::Api::Auth.configure do |c|
   #     c.get_oauth_token = {
   #       :service => {
   #         :yammer => {
   #           :client_id     => 'hoge',
   #           :client_secret => 'fuga',
   #           :user => 'test',
   #           :pass => 'test',
   #           :klass => mock
   #         }
   #       },
   #       :storage => Eventaskbot.options[:storage],
   #       :notify  => notify_opts
   #     }
   #   end
   # end
  end

  after(:each) do
   # Eventaskbot::Notifications::Yammer::CreateThread.unmock!({})
  end

  it "クラスである事の確認" do
    expect(Eventaskbot::Api::User::UserImport.class).to eq(Class)
  end

  it "APIの設定が存在しない場合のレスポンスは:fail" do
    Eventaskbot.configure do |c|
      c.api = { :name => "user-import", :type => :user }
      c.response = { :format => "json" }
    end

    api  = Eventaskbot::Api::User::UserImport.new
    res = api.execute({})
    expect(res[:status]).to eq(:fail)
  end

  it "serviceのパラメーターが存在しない場合のレスポンスは:fail" do
    Eventaskbot.configure do |c|
      c.api = { :name => "user-import", :type => :user }
      c.response = { :format => "json" }
    end

    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)

    Eventaskbot::Api::User.configure do |c|
      c.user_import = {:test => { :yammer => {:hoge => :fuga} } }
    end

    api = Eventaskbot::Api::User::UserImport.new
    res = api.execute({})
    expect(res[:status]).to eq(:fail)
  end

  it "diffオプションが正しく動作するか？" do
    Eventaskbot.configure do |c|
      c.api = { :name => "user-import", :type => :user }
      c.response = { :format => "json" }
    end

    Eventaskbot::Configurable::Merge.config_file({})
    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)

    #サービスレイヤーのモック
    mock = double(Eventaskbot::Services::Yammer::UserImport)
    mock_val = {
      :status => :ok,
      :response => { :token => 'oppopopo' },
      :message  => 'test'
    }
    allow(mock).to receive(:execute).and_return(mock_val)

    ##notifyのモック
    #mock_yam = double(Eventaskbot::Notifications::Yammer::GetOauthToken)
    #allow(mock_yam).to receive(:execute).and_return(mock_val)
    #notify_opts = Eventaskbot.options[:notify]
    #notify_opts[:klass][:yammer] = mock_yam

    #auth_configure_mock_set(mock, notify_opts)

    api = Eventaskbot::Api::User::UserImport.new
    res = api.execute({:diff_token => true})

    #expect(res[:response].key?(:old_access_token)).to eq(true)
  end

 # it "スレッドが存在しない場合はスレッドを作成できる事を確認する" do
 #   Eventaskbot.configure do |c|
 #     c.api = { :name => "get-oauth-token", :type => :auth }
 #     c.response = { :format => "json" }
 #   end

 #   Eventaskbot::Configurable::Merge.config_file({})
 #   Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)

 #   #存在するキーを削除する
 #   storage = Eventaskbot::Storage.register_driver(Eventaskbot.options[:storage])
 #   storage.del("notify_thread_id_yammer_techadmin")
## ここからコメントアウトすると実際にYammerとかに発射される
 #   #サービスレイヤーのモック
 #   mock = double(Eventaskbot::Services::Yammer::GetOauthToken)
 #   mock_val = {
 #     :status => :ok,
 #     :response => { :token => 'oppopopo' },
 #     :message  => 'test'
 #   }
 #   allow(mock).to receive(:execute).and_return(mock_val)

 #   #notifyのモック
 #   mock_yam = double(Eventaskbot::Notifications::Yammer::GetOauthToken)
 #   allow(mock_yam).to receive(:execute).and_return(mock_val)
 #   notify_opts = Eventaskbot.options[:notify]
 #   notify_opts[:klass][:yammer] = mock_yam


 #   auth_configure_mock_set(mock, notify_opts)
## ここまで

 #   get_oauth_token  = Eventaskbot::Api::Auth::GetOauthToken.new
 #   res = get_oauth_token.execute({})

 #   expect(res[:status]).to eq(:ok)
 # end
 # it "必須パラメーターが全て存在するかつその値が正しい場合は:ok" do
 #   Eventaskbot.configure do |c|
 #     c.api = { :name => "get-oauth-token", :type => :auth }
 #     c.response = { :format => "json" }
 #   end

 #   Eventaskbot::Configurable::Merge.config_file({})
 #   Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)
## ここからコメントアウトすると実際にYammerとかに発射される
 #   #サービスレイヤーのモック
 #   mock = double(Eventaskbot::Services::Yammer::GetOauthToken)
 #   mock_val = {
 #     :status => :ok,
 #     :response => { :token => 'oppopopo' },
 #     :message  => 'test'
 #   }
 #   allow(mock).to receive(:execute).and_return(mock_val)

 #   #notifyのモック
 #   mock_yam = double(Eventaskbot::Notifications::Yammer::GetOauthToken)
 #   allow(mock_yam).to receive(:execute).and_return(mock_val)
 #   notify_opts = Eventaskbot.options[:notify]
 #   notify_opts[:klass][:yammer] = mock_yam


 #   auth_configure_mock_set(mock, notify_opts)
## ここまで

 #   get_oauth_token  = Eventaskbot::Api::Auth::GetOauthToken.new
 #   res = get_oauth_token.execute({})

 #   expect(res[:status]).to eq(:ok)
 # end

end
