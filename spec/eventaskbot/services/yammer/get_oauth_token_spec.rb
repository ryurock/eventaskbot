# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/configurable'
require 'eventaskbot/services/yammer/get_oauth_token'

describe Eventaskbot::Services::Yammer::GetOauthToken, "Eventaskbot service executable on Yammer Module" do
  before(:each) do
  end

  it "クラスである事の確認" do
    expect(Eventaskbot::Services::Yammer::GetOauthToken.class).to eq(Class)
  end

  it "デフォルトステータスは:fail" do
    yam = Eventaskbot::Services::Yammer::GetOauthToken.new
    expect(yam.res[:status]).to eq(:fail)
  end

  it "必須パラメーターが存在しない場合は:fail" do
    yam = Eventaskbot::Services::Yammer::GetOauthToken.new
    opts = {}
    require_params = [:user, :pass, :client_id, :client_secret]
    require_params.each_with_index do |v, cnt|
      opts[v] = "test"
      opts.delete(:user) if cnt + 1 == require_params.size
      res = yam.execute(opts)
      expect(res[:status]).to eq(:fail)
    end
  end

  it "codeが上手く取得できない場合はエラーになる" do
    Eventaskbot.configure do |c|
      c.api = { :name => "get-oauth-token", :type => :auth }
      c.response = { :format => "json" }
    end

    Eventaskbot::Configurable::Merge.config_file({})
    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)
    opts = Eventaskbot::Api::Auth.options[:get_oauth_token][:yammer]

    #モック
    mock = double(Mechanize)

    allow(mock).to receive(:get).and_return(mock)
    allow(mock).to receive(:form_with).and_return(mock)
    allow(mock).to receive(:submit).and_return(mock)

    yam = Eventaskbot::Services::Yammer::GetOauthToken.new
    yam.client = mock
    res = yam.execute(opts)
    expect(res[:status]).to eq(:fail)
  end

  it "codeが上手く取得できた場合" do
    #モック
    mock = double(Mechanize)

    allow(mock).to receive(:get).and_return(mock)
    allow(mock).to receive(:form_with).and_return(mock)
    allow(mock).to receive(:submit).and_return(mock)
    allow(mock).to receive(:body).and_return(MultiJson.dump({:access_token => { :token => "aaabbbbcccc" } }))

    Eventaskbot.configure do |c|
      c.api = { :name => "get-oauth-token", :type => :auth }
      c.response = { :format => "json" }
    end

    Eventaskbot::Configurable::Merge.config_file({})
    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)
    opts = Eventaskbot::Api::Auth.options[:get_oauth_token][:service]

    yam = Eventaskbot::Services::Yammer::GetOauthToken.new
    yam.client = mock
    yam.code = "hoge"

    opts.each do |service,v|
      res = yam.execute(v)
      expect(res[:status]).to eq(:ok)
    end
  end
end
