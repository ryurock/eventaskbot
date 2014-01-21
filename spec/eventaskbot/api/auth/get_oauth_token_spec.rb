# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/api/auth/get_oauth_token'
require 'eventaskbot/notifications/yammer/get_oauth_token'

describe Eventaskbot::Api::Auth::GetOauthToken, "Eventaskbot Auth get-oauth-token API Class" do
  before(:each) do
    Eventaskbot::Api::Auth.reset
    Eventaskbot.reset
  end

  it "クラスである事の確認" do
    expect(Eventaskbot::Api::Auth::GetOauthToken.class).to eq(Class)
  end

  it "APIの設定が存在しない場合のレスポンスは:fail" do
    Eventaskbot.configure do |c|
      c.api = { :name => "get-oauth-token", :type => :auth }
      c.response = { :format => "json" }
    end

    get_oauth_token  = Eventaskbot::Api::Auth::GetOauthToken.new
    res = get_oauth_token.execute({})
    expect(res[:status]).to eq(:fail)
  end

  it "serviceの設定にサービスのクラスが存在しない場合は:fail" do
    Eventaskbot.configure do |c|
      c.api = { :name => "get-oauth-token", :type => :auth }
      c.response = { :format => "json" }
    end

    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)
    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = {:yammer => {:hoge => :fuga}}
    end

    get_oauth_token  = Eventaskbot::Api::Auth::GetOauthToken.new
    res = get_oauth_token.execute({})
    expect(res[:status]).to eq(:fail)
  end

  it "serviceのパラメーターが存在しない場合のレスポンスは:fail" do
    Eventaskbot.configure do |c|
      c.api = { :name => "get-oauth-token", :type => :auth }
      c.response = { :format => "json" }
    end

    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)

    get_oauth_token  = Eventaskbot::Api::Auth::GetOauthToken.new
    res = get_oauth_token.execute({})
    expect(res[:status]).to eq(:fail)
  end

  it "diffオプションが正しく動作するか？" do
    Eventaskbot.configure do |c|
      c.api = { :name => "get-oauth-token", :type => :auth }
      c.response = { :format => "json" }
    end

    Eventaskbot::Configurable::Merge.config_file({})
    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)

    #サービスレイヤーのモック
    mock = double(Eventaskbot::Services::Yammer::GetOauthToken)
    mock_val = {
      :status => :ok,
      :response => { :token => 'oppopopo' },
      :message  => 'test'
    }
    allow(mock).to receive(:execute).and_return(mock_val)

    #notifyのモック
    mock_yam = double(Eventaskbot::Notifications::Yammer::GetOauthToken)
    allow(mock_yam).to receive(:execute).and_return(mock_val)
    notify_opts = Eventaskbot.options[:notify]
    notify_opts[:klass][:yammer] = mock_yam


    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = {
        :service => {
          :yammer => {
            :client_id     => 'hoge',
            :client_secret => 'fuga',
            :user => 'test',
            :pass => 'test',
            :klass => mock
          }
        },
        :storage => Eventaskbot.options[:storage],
        :notify  => notify_opts
      }
    end
    get_oauth_token  = Eventaskbot::Api::Auth::GetOauthToken.new
    res = get_oauth_token.execute({:diff_token => true})

    expect(res[:response].key?(:old_access_token)).to eq(true)
  end

  it "必須パラメーターが全て存在するかつその値が正しい場合は:ok" do
    Eventaskbot.configure do |c|
      c.api = { :name => "get-oauth-token", :type => :auth }
      c.response = { :format => "json" }
    end

    Eventaskbot::Configurable::Merge.config_file({})
    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)
# ここからコメントアウトすると実際にYammerとかに発射される
    #サービスレイヤーのモック
    mock = double(Eventaskbot::Services::Yammer::GetOauthToken)
    mock_val = {
      :status => :ok,
      :response => { :token => 'oppopopo' },
      :message  => 'test'
    }
    allow(mock).to receive(:execute).and_return(mock_val)

    #notifyのモック
    mock_yam = double(Eventaskbot::Notifications::Yammer::GetOauthToken)
    allow(mock_yam).to receive(:execute).and_return(mock_val)
    notify_opts = Eventaskbot.options[:notify]
    notify_opts[:klass][:yammer] = mock_yam


    Eventaskbot::Api::Auth.configure do |c|
      c.get_oauth_token = {
        :service => {
          :yammer => {
            :client_id     => 'hoge',
            :client_secret => 'fuga',
            :user => 'test',
            :pass => 'test',
            :klass => mock
          }
        },
        :storage => Eventaskbot.options[:storage],
        :notify  => notify_opts
      }
    end
# ここまで

    get_oauth_token  = Eventaskbot::Api::Auth::GetOauthToken.new
    res = get_oauth_token.execute({})

    expect(res[:status]).to eq(:ok)
  end

end
