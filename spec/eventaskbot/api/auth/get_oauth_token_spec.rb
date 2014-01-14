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
    Eventaskbot.configure do |c|
      c.api = { :name => "get-oauth-token", :type => :auth }
      c.response = { :format => "json" }
      c.service = { :yammer => { :client_id => "hoge" } }
    end

    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)

    get_oauth_token  = Eventaskbot::Api::Auth::GetOauthToken.new
    res = get_oauth_token.execute({})
    expect(res[:status]).to eq(:fail)
  end


end
