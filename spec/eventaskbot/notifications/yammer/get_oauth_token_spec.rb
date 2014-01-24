# -*- coding: utf-8 -*-

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

require 'eventaskbot'
require 'eventaskbot/configurable'
require 'eventaskbot/notifications/yammer/get_oauth_token'

describe Eventaskbot::Notifications::Yammer::GetOauthToken, "Eventaskbot notifications executable on Yammer Module" do
  before(:each) do
  end

  it "クラスである事の確認" do
    expect(Eventaskbot::Notifications::Yammer::GetOauthToken.class).to eq(Class)
  end

  it "デフォルトステータスは:fail" do
    yam = Eventaskbot::Notifications::Yammer::GetOauthToken.new
    expect(yam.res[:status]).to eq(:fail)
  end

  it "必須パラメーターが存在しない場合は:fail" do
    yam = Eventaskbot::Notifications::Yammer::GetOauthToken.new
    opts = {}
    require_params = [:access_token, :client_id, :client_secret]
    require_params.each_with_index do |v, cnt|
      opts.delete(:access_token) if cnt + 1 == require_params.size
      res = yam.execute(opts)
      expect(res[:status]).to eq(:fail)
    end
  end

  it "thread_idがパラメーターに存在する場合のステータスは:ok" do
    Eventaskbot.configure do |c|
      c.api = { :name => "get-oauth-token", :type => :auth }
      c.response = { :format => "json" }
    end

    Eventaskbot::Configurable::Merge.config_file({})
    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)
    opts = Eventaskbot::Api::Auth.options[:get_oauth_token][:service][:yammer]
    opts[:access_token] = "xxxxxxxxxxxxx"
    opts[:thread_id] = 10000000000

    #モック
    mock = double(::Yammer::Client)

    allow(mock).to receive(:create_message).and_return(nil)

    yam = Eventaskbot::Notifications::Yammer::GetOauthToken.new
    yam.client = mock
    res = yam.execute(opts)
    expect(res[:status]).to eq(:ok)
  end

  it "レスポンスコードが２００ではない場合は:fail" do
    Eventaskbot.configure do |c|
      c.api = { :name => "get-oauth-token", :type => :auth }
      c.response = { :format => "json" }
    end

    Eventaskbot::Configurable::Merge.config_file({})
    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)
    opts = Eventaskbot::Api::Auth.options[:get_oauth_token][:service][:yammer]
    opts[:access_token] = "xxxxxxxxxxxxx"

    #モック
    mock     = double(::Yammer::Client)
    mock_res = double(::Yammer::ApiResponse)

    allow(mock).to receive(:create_message).and_return({})
    allow(mock).to receive(:all_groups).and_return(mock_res)
    allow(mock_res).to receive(:code).and_return(400)

    yam = Eventaskbot::Notifications::Yammer::GetOauthToken.new
    yam.client = mock
    res = yam.execute(opts)
    expect(res[:status]).to eq(:fail)
  end

  it "グループ情報が取得できない場合は:fail" do
    Eventaskbot.configure do |c|
      c.api = { :name => "get-oauth-token", :type => :auth }
      c.response = { :format => "json" }
    end

    Eventaskbot::Configurable::Merge.config_file({})
    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)
    opts = Eventaskbot::Api::Auth.options[:get_oauth_token][:service][:yammer]
    opts[:access_token] = "xxxxxxxxxxxxx"
    opts[:group] = { :yammer => [:hoge] }

    #モック
    mock     = double(::Yammer::Client)
    mock_res = double(::Yammer::ApiResponse)

    allow(mock).to receive(:create_message).and_return({})
    allow(mock).to receive(:all_groups).and_return(mock_res)
    allow(mock_res).to receive(:code).and_return(200)
    allow(mock_res).to receive(:body).and_return([{:name => "fuga"}])

    yam = Eventaskbot::Notifications::Yammer::GetOauthToken.new
    yam.client = mock
    res = yam.execute(opts)
    expect(res[:status]).to eq(:fail)
  end

  it "グループ情報が取得できた場合は:ok" do
    Eventaskbot.configure do |c|
      c.api = { :name => "get-oauth-token", :type => :auth }
      c.response = { :format => "json" }
    end

    Eventaskbot::Configurable::Merge.config_file({})
    Eventaskbot::Configurable::Filter.filter(Eventaskbot.options)
    opts = Eventaskbot::Api::Auth.options[:get_oauth_token][:service][:yammer]
    opts[:access_token] = "xxxxxxxxxxxxx"
    opts[:group] = { :yammer => [:hoge] }

    #モック
    mock     = double(::Yammer::Client)
    mock_res = double(::Yammer::ApiResponse)

    allow(mock).to receive(:create_message).and_return({})
    allow(mock).to receive(:all_groups).and_return(mock_res)
    allow(mock_res).to receive(:code).and_return(200)
    allow(mock_res).to receive(:body).and_return([{:name => "hoge"}])

    yam = Eventaskbot::Notifications::Yammer::GetOauthToken.new
    yam.client = mock
    res = yam.execute(opts)
    expect(res[:status]).to eq(:ok)
  end
end
