# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

plugins_path = File.expand_path('../../../../../plugins', __FILE__)
$LOAD_PATH.unshift(plugins_path) unless $LOAD_PATH.include?(plugins_path)
require 'eventaskbot'
require 'eventaskbot/api/auth/get_oauth_token'
require 'eventaskbot-yammer-plugins/yammer'

describe Eventaskbot::Api::Auth::GetOauthToken, "Eventaskbot Auth get-oauth-token API Class" do
  before(:each) do
    Eventaskbot::Api::Auth.reset
    Eventaskbot.reset
  end

  it "クラスである事の確認" do
    expect(Eventaskbot::Api::Auth::GetOauthToken.class).to eq(Class)
  end

  it "serviceのパラメーターが存在しない場合のレスポンスは:fail" do
    get_oauth_token  = Eventaskbot::Api::Auth::GetOauthToken.new
    res = get_oauth_token.execute({})
    expect(res[:status]).to eq(:fail)
  end

  it "設定値がHashではない場合は:fail" do
    params = {
      :service => {
        :yammer => :hoge
      }
    }
    get_oauth_token  = Eventaskbot::Api::Auth::GetOauthToken.new
    res = get_oauth_token.execute(params)
    expect(res[:status]).to eq(:fail)
  end

  it "serviceの設定に:klassがない場合は:fail" do
    params = {
      :service => {
        :yammer => {
          :user => 'hoge@example.com',
        }
      }
    }
    get_oauth_token  = Eventaskbot::Api::Auth::GetOauthToken.new
    res = get_oauth_token.execute(params)
    expect(res[:status]).to eq(:fail)
  end

  it "serviceのパラメーターは存在するが:passのパラメーターが存在しない場合は:fail" do
    params = {
      :service => {
        :yammer => {
          :user => 'hoge@example.com',
          :klass => Eventaskbot::Plugins::Yammer.new
        }
      }
    }
    get_oauth_token  = Eventaskbot::Api::Auth::GetOauthToken.new
    res = get_oauth_token.execute(params)
    expect(res[:status]).to eq(:fail)
  end

  it "serviceのパラメーターは存在するが:userのパラメーターが存在しない場合は:fail" do
    params = {
      :service => {
        :yammer => {
          :pass => 'hoge',
          :klass => Eventaskbot::Plugins::Yammer.new
        }
      }
    }
    get_oauth_token  = Eventaskbot::Api::Auth::GetOauthToken.new
    res = get_oauth_token.execute(params)
    expect(res[:status]).to eq(:fail)
  end

  it "serviceのパラメー" do
    Eventaskbot.configure do |c|
      c.service = {:yammer => { :client_id => 'hoge', :client_secret => "fuga"} }
    end

    params = {
      :service => {
        :yammer => {
          :user  => 'hoge@example.com',
          :pass  => 'fuga',
          :klass => Eventaskbot::Plugins::Yammer.new
        }
      }
    }
    get_oauth_token  = Eventaskbot::Api::Auth::GetOauthToken.new
    res = get_oauth_token.execute(params)
    expect(res[:status]).to eq(:ok)
  end
end
